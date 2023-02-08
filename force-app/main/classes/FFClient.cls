public class FFClient {

    private final String sdkKey;
    private final FFConfig config;
    private final FFClientApi api;

    private String environmentUUID;
    private String cluster = '1';

    private static Integer maxRetry = 5;
    private final Long waitInterval = 2000;

    public virtual class AuthException extends Exception {}

    public FFClient(FFClientApi api, FFConfig config, String environmentUUID, String cluster) {
        this.sdkKey = sdkKey;
        this.config = config;
        this.api = api;
        this.environmentUUID = environmentUUID;
        this.cluster = cluster;
    }

    private Map<String, String> envAndClusterRequestParams() {
        return new Map<String, String> { 'environmentUUID' => this.environmentUUID, 'cluster' => this.cluster };
    }

    public static FFClient create(String sdkKey, FFConfig config) {
        FFBaseCallout client = new FFBaseCallout(config);
        FFClientApi api = new FFClientApi(client);
        FFAuthService authService = new FFCachedAuthService(sdkKey, config, api);
        FFAuthResult authResult = authService.authenticate();
        client.setJWTToken(authResult.authToken);
        return new FFClient(api, config, authResult.environmentUUID, authResult.cluster);
    }

    private String getEvalCacheKey(String identifier, String target) {
        return config.getCache().getCacheNamespace() + '.' + config.getCache().getCachePartition() + '.feature' + this.removeSpecChars(identifier) +
                removeSpecChars(target);
    }

    private String removeSpecChars(String s) {
        String text = s.substring(0);
        return text.replaceAll('[^a-zA-Z0-9\\s+]', '');
    }

    private List<FFFeatureConfig> getFeatureConfigs() {
        FFCache cache = this.config.getCache();
        List<FFFeatureConfig> featureConfigs = (List<FFFeatureConfig>) cache.get(FFCacheKeys.getFeatureConfigsKey(cache));
        if(featureConfigs == null) {
            List<FFFeatureConfig> updated = this.api.getFeatureConfigs(this.envAndClusterRequestParams());
            cache.put(FFCacheKeys.getFeatureConfigsKey(cache), updated, this.config.getFeatureConfigTimeToLive());
            return updated;
        }
        return featureConfigs;
    }

    private List<FFTargetSegment> getTargetSegments() {
        FFCache cache = this.config.getCache();
        List<FFTargetSegment> targetSegments = (List<FFTargetSegment>) cache.get(FFCacheKeys.getTargetSegmentsKey(cache));
        if(targetSegments == null) {
            List<FFTargetSegment> updated = this.api.getTargetSegments(this.envAndClusterRequestParams());
            cache.put(FFCacheKeys.getTargetSegmentsKey(cache), updated, this.config.getFeatureConfigTimeToLive());
            return updated;
        }
        return targetSegments;
    }

    private static FFFeatureConfig getFlag(List<FFFeatureConfig> featureConfigs, String key) {
        for(FFFeatureConfig featureConfig: featureConfigs) {
            if(featureConfig.feature == key) return featureConfig;
        }
        return null;
    }

    private FFFeatureVariation offVariation(FFFeatureConfig featureConfig) {
        for(FFFeatureVariation variation: featureConfig.variations){
            if(variation.identifier == featureConfig.offVariation) {
                return variation;
            }
        }
        return null;
    }


    private FFFeatureVariation evaluateVariation(String key, FFTarget target, String kind) {
        List<FFFeatureConfig> featureConfigs = this.getFeatureConfigs();
        FFFeatureConfig featureConfig = FFClient.getFlag(featureConfigs, key);
        if(featureConfig == null || featureConfig.kind != kind){
            return null;
        }
        FFSegmentEvaluator segmentEvaluator = new FFSegmentEvaluator(this.getTargetSegments());
        FFFeatureEvaluator evaluator = FFFeatureEvaluator.defaultEvaluators(segmentEvaluator);
        FFPrerequisites prerequisites = new FFPrerequisites(featureConfigs, evaluator);
        if(!prerequisites.passesPrerequisiteChecks(featureConfig, target)) {
            return this.offVariation(featureConfig);
        }
        return evaluator.evaluate(featureConfig, target);
    }

    // public List<FFEvaluation> fetchEvaluations() {
    //     Map<String, Object> params = new Map<String, Object>{
    //         'environmentUUID' => this.envUUID,
    //         'target' => this.target.identifier,
    //         'cluster' => this.cluster
    //     };
    //     try {
    //         List<FFEvaluation> evals = api.getEvaluations(params);
    //         for (FFEvaluation eval: evals) {
    //             config.getCache().put(this.getEvalCacheKey(eval.flag, this.target.identifier), eval, config.getEvalExpireAfter());
    //         }
    //         return evals;
    //     } catch (FFBase.ApiException e) {
    //         if (FFClient.retryCount <= FFClient.maxRetry && e.getStatusCode() == 403 && authenticate()) {
    //             sleep(waitInterval * FFClient.retryCount);
    //             return fetchEvaluations();
    //         }
    //         throw e;
    //     }
    // }

    // public FFEvaluation evaluate(String identifier, Object defaultValue) {
    //     Map<String, Object> params = new Map<String, Object>{
    //         'feature' => identifier,
    //         'environmentUUID' => this.envUUID,
    //         'target' => this.target.identifier,
    //         'cluster' => this.cluster
    //     };
    //     try {
    //         FFEvaluation eval = (FFEvaluation) config.getCache().get(this.getEvalCacheKey(identifier, this.target.identifier));
    //         if (eval != null) {
    //             System.debug('Loading evaluation from cache: ' + identifier);
    //             return eval;
    //         }
    //         eval = api.getEvaluationByIdentifier(params);
    //         System.debug('Loading evaluation from remote url ' + identifier);
    //         config.getCache().put(this.getEvalCacheKey(eval.flag, this.target.identifier), eval, config.getEvalExpireAfter());
    //         return eval;
    //     } catch (FFBase.ApiException e) {
    //         if (FFClient.retryCount <= FFClient.maxRetry && e.getStatusCode() == 403 && authenticate()) {
    //             sleep(waitInterval * FFClient.retryCount);
    //             return evaluate(identifier, defaultValue);
    //         }
    //         throw e;
    //     }
    // }

    public FFEvaluation evaluate(String identifier, Object defaultValue) {
        return null;
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
