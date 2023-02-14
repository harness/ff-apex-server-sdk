@isTest
private class FFCachedAuthServiceTest {

    private class MockCache implements FFCache {
        public Map<String, Object> cache {get;set;}
        public MockCache() {
            this.cache = new Map<String, Object>();
        }
        public void put(String key, Object value, Integer ttl) { this.cache.put(key, value); }
        public Object get(String key) { return this.cache.get(key);}
        public String getCacheNamespace() { return 'TEST'; }
        public String getCachePartition() { return 'TEST'; }
    }

    private class MockAuthenticator implements FFAuthenticator {
        public Integer called { get; set; }
        public Integer throwTimes { get; set; }
        public FFAuthenticationResponse response {get;set;}
        public MockAuthenticator(FFAuthenticationResponse response) {
            this.response = response;
            this.called = 0;
            this.throwTimes = 0;
        }
        public MockAuthenticator(FFAuthenticationResponse successResponse, Integer throwTimes) {
            this.called = 0;
            this.response = successResponse;
            this.throwTimes = throwTimes;
        }
        public FFAuthenticationResponse authenticate(Map<String, Object> params) {
            this.called++;
            if(this.called <= this.throwTimes) {
                throw new FFBase.ApiException(403, 'Forbidden', new Map<String,String>(), '');
            }
            return this.response;
        }
    }

    @isTest
    private static void shouldStoreClaimsInCacheWithJWT() {
       FFConfig config = FFConfig.builder().cache(new MockCache()).build();
       FFAuthenticationResponse response = new FFAuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response);
       FFCachedAuthService authService = new FFCachedAuthService('test-sdk-key', config, authenticator);
       FFAuthResult result = authService.authenticate();
       System.assertEquals('2', result.cluster);
       System.assertEquals('test-env', result.environmentUUID);
       String cacheKey = FFCacheKeys.getAuthCacheKey(config.cache, 'test-sdk-key');
       Map<String, String> stored = (Map<String, String>)config.cache.get(cacheKey);
       System.assertEquals(stored.get('environmentUUID'), 'test-env');
       System.assertEquals(stored.get('cluster'), '2');
       System.assertEquals(stored.get('jwt'), response.authToken);
    }

    @isTest
    private static void shouldRetryAuthenticationOn403() {
       FFConfig config = FFConfig.builder().cache(new MockCache()).build();
       FFAuthenticationResponse response = new FFAuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response, 2); // FAIL TWICE
       FFCachedAuthService authService = new FFCachedAuthService('test-sdk-key', config, authenticator);
       FFAuthResult result = authService.authenticate();
       System.assertEquals('2', result.cluster);
       System.assertEquals('test-env', result.environmentUUID);
       System.assertEquals(3, authenticator.called); // CALLED THREE TIMES
    }

    @isTest
    private static void shouldRetry10TimesMaxByDefault() {
       FFConfig config = FFConfig.builder().cache(new MockCache()).build();
       FFAuthenticationResponse response = new FFAuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response, 20); // FAIL More than max times
       FFCachedAuthService authService = new FFCachedAuthService('test-sdk-key', config, authenticator);
       try {
            FFAuthResult result = authService.authenticate();
            System.assert(false, 'Shouldn\'t get here');
       } catch(Exception e) {
            System.assertEquals(11, authenticator.called); // CALLED 1 Initial time + 10 Retries
       }
    }

    @isTest
    private static void shouldRetryMaxTimesSpecifiedByConfig() {
       FFConfig config = FFConfig.builder().cache(new MockCache()).authRetries(4).build();
       FFAuthenticationResponse response = new FFAuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response, 20); // FAIL More than max times
       FFCachedAuthService authService = new FFCachedAuthService('test-sdk-key', config, authenticator);
       try {
            FFAuthResult result = authService.authenticate();
            System.assert(false, 'Shouldn\'t get here');
       } catch(Exception e) {
            System.assertEquals(5, authenticator.called); // CALLED 1 Initial time + 10 Retries
       }
    }
}