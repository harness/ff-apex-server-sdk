public class FFClient {

    private final String sdkKey;
    private final FFConfig config;
    private final FFBaseCallout client;
    private final FFClientApi api;
    private final FFTarget target;

    private String envUUID;
    private String cluster = '1';

    private static Integer retryCount = 1;
    private static Integer maxRetry = 5;
    private final Long waitInterval = 2000;

    public virtual class AuthException extends Exception {}

    public FFClient(String sdkKey, FFTarget target, FFConfig config) {
        this.sdkKey = sdkKey;
        this.config = config;
        this.target = target;
        this.client = new FFBaseCallout(this.config);
        this.api = new FFClientApi(client);

        if (Cache.Org.get(getAuthCacheKey()) != null) {
            System.debug('Loading authentication data from cache');
            Map<String, String> authData = (Map<String, String>) Cache.Org.get(this.getAuthCacheKey());
            this.envUUID = authData.get('envUUID');
            this.cluster = authData.get('cluster');
            this.client.setJWTToken(authData.get('jwt'));
        } else {
            System.debug('Authentication token not found in cache, authenticating...');
            authenticate();
        }
    }

    private String getAuthCacheKey() {
        return this.config.getCacheNamespace() + '.' + this.config.getCachePartition() + '.auth' + this.sdkKey.replaceAll('-', '');
    }

    private String getEvalCacheKey(String identifier, String target) {
        return this.config.getCacheNamespace() + '.' + this.config.getCachePartition() + '.feature' + this.removeSpecChars(identifier) +
        removeSpecChars(target);
    }

    private String removeSpecChars(String s) {
        String text = s.substring(0);
        return text.replaceAll('[^a-zA-Z0-9\\s+]', '');
    }

    private Boolean authenticate() {
        FFAuthenticationRequestTarget targetData = new FFAuthenticationRequestTarget();
        targetData.identifier = this.target.identifier;
        targetData.name = this.target.name;
        targetData.anonymous = this.target.anonymous;
        targetData.attributes = this.target.attributes;

        FFAuthenticationRequest req = new FFAuthenticationRequest();
        req.apiKey = this.sdkKey;
        req.target = targetData;


        Map<String, Object> params = new Map<String, Object>{
            'ffAuthenticationRequest' => req
        };

        try {
            FFAuthenticationResponse result = api.authenticate(params);
            String authToken = result.authToken;

            this.client.setJWTToken(authToken);

            List<String> parts = authToken.split('\\.');
            if (parts.size() != 3) {
                throw new AuthException('JWT token not valid! parts: ' + parts.size());
            }
            String decoded = EncodingUtil.base64Decode(parts.get(1)).toString();
            FFJWTClaims claims = (FFJWTClaims)JSON.deserialize(decoded, FFJWTClaims.class);
            this.envUUID = claims.environment;
            this.cluster = claims.clusterIdentifier;
            Cache.Org.put(getAuthCacheKey(), new Map<String, String>{
                'envUUID' => this.envUUID,
                'cluster' => this.cluster,
                'jwt' => authToken
            }, this.config.getAuthExpireAfter());
            System.debug('Env UUID ' + this.envUUID);
            System.debug('Cluster ID ' + this.cluster);
            FFClient.retryCount = 0;
            return true;
        } catch (FFBase.ApiException e) {
            System.debug(e);
            throw e;
        }
    }

    public List<FFEvaluation> fetchEvaluations() {
        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => this.envUUID,
            'target' => this.target.identifier,
            'cluster' => this.cluster
        };
        try {
            List<FFEvaluation> evals = api.getEvaluations(params);
            for (FFEvaluation eval: evals) {
                Cache.Org.put(this.getEvalCacheKey(eval.flag, this.target.identifier), eval, this.config.getEvalExpireAfter());
            }
            return evals;
        } catch (FFBase.ApiException e) {
            if (FFClient.retryCount <= FFClient.maxRetry && e.getStatusCode() == 403 && authenticate()) {
                sleep(waitInterval * FFClient.retryCount);
                return fetchEvaluations();
            }
            throw e;
        }
    }

    public FFEvaluation evaluate(String identifier, Object defaultValue) {
        Map<String, Object> params = new Map<String, Object>{
            'feature' => identifier,
            'environmentUUID' => this.envUUID,
            'target' => this.target.identifier,
            'cluster' => this.cluster
        };
        try {
            FFEvaluation eval = (FFEvaluation) Cache.Org.get(this.getEvalCacheKey(identifier, this.target.identifier));
            if (eval != null) {
                System.debug('Loading evaluation from cache: ' + identifier);
                return eval;
            }
            eval = api.getEvaluationByIdentifier(params);
            System.debug('Loading evaluation from remote url ' + identifier);
            Cache.Org.put(this.getEvalCacheKey(eval.flag, this.target.identifier), eval, this.config.getEvalExpireAfter());
            return eval;
        } catch (FFBase.ApiException e) {
            if (FFClient.retryCount <= FFClient.maxRetry && e.getStatusCode() == 403 && authenticate()) {
                sleep(waitInterval * FFClient.retryCount);
                return evaluate(identifier, defaultValue);
            }
            throw e;
        }
    }

    public Boolean evaluate(String identifier, Boolean defaultValue) {
        try {
            FFEvaluation evaluation = evaluate(identifier, (Object) defaultValue);
            if (!evaluation.kind.equals('boolean')) {
                return defaultValue;
            }
            return evaluation.value.toLowerCase() == 'true';
        } catch (FFBase.ApiException e) {
            System.debug('Exception raised on bool evaluate with message: ' + e.getMessage());
            return defaultValue;
        }
    }

    public String evaluate(String identifier, String defaultValue) {
        try {
            FFEvaluation evaluation = evaluate(identifier, (Object) defaultValue);
            if (!evaluation.kind.equals('string')) {
                return defaultValue;
            }
            return evaluation.value;
        } catch (FFBase.ApiException e) {
            System.debug('Exception raised on string evaluate with message: ' + e.getMessage());
            return defaultValue;
        }
    }

    public Double evaluate(String identifier, Double defaultValue) {
        try {
            FFEvaluation evaluation = evaluate(identifier, (Object) defaultValue);
            if (!evaluation.kind.equals('int')) {
                return defaultValue;
            }
            return Double.valueOf(evaluation.value);
        } catch (FFBase.ApiException e) {
            System.debug('Exception raised on number evaluate with message: ' + e.getMessage());
            return defaultValue;
        }
    }

    public Map<String, Object> evaluate(String identifier, Map<String, Object> defaultValue) {
        try {
            FFEvaluation evaluation = evaluate(identifier, (Object) defaultValue);
            if (!evaluation.kind.equals('json')) {
                return defaultValue;
            }
            String value = evaluation.value.unescapeUnicode();
            if (value.length() > 2 && value.startsWith('"')) {
                value = value.substring(1, value.length() - 1);
            }
            return (Map<String, Object>) JSON.deserializeUntyped(value);
        } catch (FFBase.ApiException e) {
            System.debug('Exception raised on json evaluate with message: ' + e.getMessage());
            return defaultValue;
        }
    }

    private void sleep(Long ms) {
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < ms) {
            //sleep for 9s
            finishTime = DateTime.now().getTime();
        }
    }
}
