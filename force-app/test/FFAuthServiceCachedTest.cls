@isTest
private class FFAuthServiceCachedTest {

    private class MockAuthenticator implements FFAuthenticator {
        public Integer called { get; set; }
        public Integer throwTimes { get; set; }
        public FFModels.AuthenticationResponse response {get;set;}
        public MockAuthenticator(FFModels.AuthenticationResponse response) {
            this.response = response;
            this.called = 0;
            this.throwTimes = 0;
        }
        public MockAuthenticator(FFModels.AuthenticationResponse successResponse, Integer throwTimes) {
            this.called = 0;
            this.response = successResponse;
            this.throwTimes = throwTimes;
        }
        public FFModels.AuthenticationResponse authenticate(Map<String, Object> params) {
            this.called++;
            if(this.called <= this.throwTimes) {
                throw new FFBase.ApiException(403, 'Forbidden', new Map<String,String>(), '');
            }
            return this.response;
        }
    }

    @isTest
    private static void shouldStoreClaimsInCacheWithJWT() {
       FFConfig config = FFConfig.builder().cache(new FFMockCache()).build();
       FFModels.AuthenticationResponse response = new FFModels.AuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response);
       FFAuthServiceCached authService = new FFAuthServiceCached('test-sdk-key', config, authenticator);
       FFModels.AuthInfo result = authService.authenticate(false);
       System.assertEquals('2', result.cluster);
       System.assertEquals('test-env', result.environmentUUID);
       String authCacheKey = FFCacheKeys.getCacheKey('test-sdk-key');
       Map<String, String> stored = (Map<String, String>)config.cache.getKey('auth'+authCacheKey);
       System.assertEquals(stored.get('environmentUUID'), 'test-env');
       System.assertEquals(stored.get('cluster'), '2');
       System.assertEquals(stored.get('jwt'), response.authToken);

       // Ensure lastAuthTime gets cached
       String lastAuthKey = FFCacheKeys.getCacheKey('test-sdk-key');
       String lastAuth = config.cache.getLastAuthKey('lastAuth'+lastAuthKey);
       // Just assert that the key is there. We can't verify the timestamp in the test.
       System.assertNotEquals(lastAuth, null);
    }



    @isTest
    private static void shouldRetryAuthenticationOn403() {
       FFConfig config = FFConfig.builder().cache(new FFMockCache()).build();
       FFModels.AuthenticationResponse response = new FFModels.AuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response, 2); // FAIL TWICE
       FFAuthServiceCached authService = new FFAuthServiceCached('test-sdk-key', config, authenticator);
       FFModels.AuthInfo result = authService.authenticate(false);
       System.assertEquals('2', result.cluster);
       System.assertEquals('test-env', result.environmentUUID);
       System.assertEquals(3, authenticator.called); // CALLED THREE TIMES
    }

    @isTest
    private static void shouldRetry10TimesMaxByDefault() {
       FFConfig config = FFConfig.builder().cache(new FFMockCache()).build();
       FFModels.AuthenticationResponse response = new FFModels.AuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response, 20); // FAIL More than max times
       FFAuthServiceCached authService = new FFAuthServiceCached('test-sdk-key', config, authenticator);
       try {
        FFModels.AuthInfo result = authService.authenticate(false);
            System.assert(false, 'Shouldn\'t get here');
       } catch(Exception e) {
            System.assertEquals(11, authenticator.called); // CALLED 1 Initial time + 10 Retries
       }
    }

    @isTest
    private static void shouldRetryMaxTimesSpecifiedByConfig() {
       FFConfig config = FFConfig.builder().cache(new FFMockCache()).authRetries(4).build();
       FFModels.AuthenticationResponse response = new FFModels.AuthenticationResponse();
       response.authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbnZpcm9ubWVudCI6InRlc3QtZW52IiwiY2x1c3RlcklkZW50aWZpZXIiOiIyIiwiaWF0IjoxNTE2MjM5MDIyfQ.J806LOlfV15bTVzQVNfKil8VGQOVadXcXpfqTJ_xrZM';
       MockAuthenticator authenticator = new MockAuthenticator(response, 20); // FAIL More than max times
       FFAuthServiceCached authService = new FFAuthServiceCached('test-sdk-key', config, authenticator);
       try {
        FFModels.AuthInfo result = authService.authenticate(false);
            System.assert(false, 'Shouldn\'t get here');
       } catch(Exception e) {
            System.assertEquals(5, authenticator.called); // CALLED 1 Initial time + 10 Retries
       }
    }
}