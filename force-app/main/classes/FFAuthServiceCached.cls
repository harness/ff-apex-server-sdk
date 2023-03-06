public class FFAuthServiceCached implements FFAuthService {

    private final FFAuthenticator authenticator;
    private final FFConfig config;
    private final String sdkKey;

    private final String CACHE_KEY_ENVIRONMENT = 'environmentUUID';
    private final String CACHE_KEY_CLUSTER = 'cluster';
    private final String CACHE_KEY_JWT = 'jwt';

    public virtual class AuthException extends Exception {}

    public FFAuthServiceCached(String sdkKey, FFConfig config, FFAuthenticator authenticator) {
        this.sdkKey = sdkKey;
        this.config = config;
        this.authenticator = authenticator;
    }

    private void updateAuthInCache(FFModels.AuthInfo claims) {
        this.config.cache.put(this.getAuthCacheKey(), new Map<String, String>{
            CACHE_KEY_ENVIRONMENT => claims.environmentUUID,
            CACHE_KEY_CLUSTER => claims.cluster,
            CACHE_KEY_JWT => claims.authToken
        }, this.config.authExpireAfter);
    }

    private FFModels.AuthInfo claimsFromCache() {
        Map<String, String> authData = (Map<String, String>)this.config.cache.get(this.getAuthCacheKey());
        if(authData == null) return null;
        System.debug('Loading authentication data from cache');
        return new FFModels.AuthInfo(authData.get(CACHE_KEY_JWT), authData.get(CACHE_KEY_ENVIRONMENT), authData.get(CACHE_KEY_CLUSTER));
    }

    private String getAuthCacheKey() {
        return FFCacheKeys.getAuthCacheKey(this.config.cache, this.sdkKey);
    }

    public FFModels.AuthInfo authenticate() {
        FFModels.AuthInfo claims = this.claimsFromCache();
        if(claims != null) return claims;
        System.debug('Authentication token not found in cache, authenticating...');
        return this.reauthenticate(0);
    }

    private FFModels.JWTClaims claimsFrom(String authToken) {
        List<String> parts = authToken.split('\\.');
        if (parts.size() != 3) {
            throw new AuthException('JWT token not valid! parts: ' + parts.size());
        }
        String decoded = EncodingUtil.base64Decode(parts.get(1)).toString();
        return (FFModels.JWTClaims)JSON.deserialize(decoded, FFModels.JWTClaims.class);
    }

    private FFModels.AuthInfo reauthenticate(Integer retry) {
        FFModels.AuthenticationRequest request = new FFModels.AuthenticationRequest();
        request.apiKey = this.sdkKey;
        request.target = new Map<String,String>{ 'identifier' => '' };
        try {
            FFModels.AuthenticationResponse result = this.authenticator.authenticate(new Map<String, Object>{'ffAuthenticationRequest' => request});
            FFModels.JWTClaims claims = this.claimsFrom(result.authToken);
            FFModels.AuthInfo authClaims = new FFModels.AuthInfo(result.authToken, claims.environment, claims.clusterIdentifier);
            this.updateAuthInCache(authClaims);
            System.debug('Env UUID ' + authClaims.environmentUUID);
            System.debug('Cluster ID ' + authClaims.cluster);
            return authClaims;
        } catch (FFBase.ApiException e) {
            System.debug('Auth Error');
            System.debug(e);
            if(e.getStatusCode() == 403) {
                if(retry < this.config.authRetries) {
                    System.debug('Retrying authentication, retry no. ' + retry);
                    return this.reauthenticate(retry + 1);
                }
            }
            throw e;
        }
    }
}