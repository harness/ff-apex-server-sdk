public class FFCachedAuthService implements FFAuthService {

    private final FFClientApi api;
    private final FFConfig config;
    private final String sdkKey;

    private final String CACHE_KEY_ENVIRONMENT = 'environmentUUID';
    private final String CACHE_KEY_CLUSTER = 'cluster';
    private final String CACHE_KEY_JWT = 'jwt';

    public virtual class AuthException extends Exception {}

    public FFCachedAuthService(String sdkKey, FFConfig config, FFClientApi api) {
        this.sdkKey = sdkKey;
        this.config = config;
        this.api = api;
    }

    private void updateAuthInCache(FFAuthResult claims) {
        this.config.getCache().put(getAuthCacheKey(), new Map<String, String>{
            CACHE_KEY_ENVIRONMENT => claims.environmentUUID,
            CACHE_KEY_CLUSTER => claims.cluster,
            CACHE_KEY_JWT => claims.authToken
        }, this.config.getAuthExpireAfter());
    }

    private FFAuthResult claimsFromCache() {
        Map<String, String> authData = (Map<String, String>)this.config.getCache().get(this.getAuthCacheKey());
        if(authData == null) return null;
        System.debug('Loading authentication data from cache');
        return new FFAuthResult(authData.get(CACHE_KEY_JWT), authData.get(CACHE_KEY_ENVIRONMENT), authData.get(CACHE_KEY_CLUSTER));
    }

    private String getAuthCacheKey() {
        return FFCacheKeys.getAuthCacheKey(this.config.getCache(), this.sdkKey);
    }

    public FFAuthResult authenticate() {
        FFAuthResult claims = this.claimsFromCache();
        if(claims != null) return claims;
        System.debug('Authentication token not found in cache, authenticating...');
        return this.reauthenticate();
    }

    private FFAuthResult reauthenticate() {
        FFAuthenticationRequest request = new FFAuthenticationRequest();
        request.apiKey = this.sdkKey;
        request.target = new Map<String,String>{ 'identifier' => '' };
        try {
            FFAuthenticationResponse result = api.authenticate(new Map<String, Object>{'ffAuthenticationRequest' => request});
            String authToken = result.authToken;

            List<String> parts = authToken.split('\\.');
            if (parts.size() != 3) {
                throw new AuthException('JWT token not valid! parts: ' + parts.size());
            }
            String decoded = EncodingUtil.base64Decode(parts.get(1)).toString();
            FFJWTClaims claims = (FFJWTClaims)JSON.deserialize(decoded, FFJWTClaims.class);
            FFAuthResult authClaims = new FFAuthResult(authToken, claims.environment, claims.clusterIdentifier);
            this.updateAuthInCache(authClaims);

            System.debug('Env UUID ' + authClaims.environmentUUID);
            System.debug('Cluster ID ' + authClaims.cluster);
            return authClaims;
        } catch (FFBase.ApiException e) {
            System.debug('Auth Error');
            System.debug(e);
            throw e;
        }
    }
}