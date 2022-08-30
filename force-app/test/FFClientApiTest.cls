@isTest
private class FFClientApiTest {

    class MockCache implements FFCache {
        private Map<String, Object> cache;
        public MockCache() {
            cache = new Map<String,Object>();
        }

        public void put(String key, Object value, Integer ttl) {
            cache.put(key, value);
        }

        public Object get(String key) {
            return cache.get(key);
        }

        public String getCacheNamespace() {
            return 'test';
        }

        public String getCachePartition() {
            return 'test';
        }
    }

    /**
     * Authenticate with the admin server.
     *
     * Used to retrieve all target segments for certain account id.
     */
    @isTest
    private static void authenticateTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        FFAuthenticationRequest req = new FFAuthenticationRequest();

        Map<String, Object> params = new Map<String, Object>{
            'ffAuthenticationRequest' => req
        };

        MockCache cache = new MockCache();
        FFBaseCallout client = new FFBaseCallout(FFConfig.builder().cache(cache).build());
        FFClientApi api = new FFClientApi(client);

        FFAuthenticationResponse response;
        FFAuthenticationResponse expectedResponse;
        String js = '';

        js = JSON.serialize(FFAuthenticationResponse.getExample());
        res.setHeader('Content-Type', 'application/json');
        res.setBody(js);
        expectedResponse = FFAuthenticationResponse.getExample();
        response = (FFAuthenticationResponse) api.authenticate(params);
        System.assertEquals(expectedResponse, response);
    }

    /**
     * Get feature evaluations for target
     *
     * 
     */
    @isTest
    private static void getEvaluationByIdentifierTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'null',
            'feature' => 'null',
            'target' => 'null',
            'cluster' => 'null'
        };

        MockCache cache = new MockCache();
        FFBaseCallout client = new FFBaseCallout(FFConfig.builder().cache(cache).build());
        FFClientApi api = new FFClientApi(client);

        FFEvaluation response;
        FFEvaluation expectedResponse;
        String js = '';

        js = JSON.serialize(FFEvaluation.getExample());
        res.setHeader('Content-Type', 'application/json');
        res.setBody(js);
        expectedResponse = FFEvaluation.getExample();
        response = (FFEvaluation) api.getEvaluationByIdentifier(params);
        System.assertEquals(expectedResponse, response);
    }

    /**
     * Get feature evaluations for target
     *
     * 
     */
    @isTest
    private static void getEvaluationsTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'null',
            'target' => 'null',
            'cluster' => 'null'
        };

        MockCache cache = new MockCache();
        FFBaseCallout client = new FFBaseCallout(FFConfig.builder().cache(cache).build());
        FFClientApi api = new FFClientApi(client);
        List<FFEvaluation> response;
        List<FFEvaluation> expectedResponse;
        String js = '';

        // js = JSON.serialize(List.getExample());
        // res.setHeader('Content-Type', 'application/json');
        // res.setBody(js);
        // expectedResponse = List.getExample();
        // response = (List<FFEvaluation>) api.getEvaluations(params);
        // System.assertEquals(expectedResponse, response);
    }

    /**
     * Stream endpoint.
     *
     * 
     */
    @isTest
    private static void streamTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'apIKey' => 'null',
            'cluster' => 'null'
        };

        String js = '';

        MockCache cache = new MockCache();
        FFBaseCallout client = new FFBaseCallout(FFConfig.builder().cache(cache).build());
        FFClientApi api = new FFClientApi(client);
        api.stream(params);
    }
}