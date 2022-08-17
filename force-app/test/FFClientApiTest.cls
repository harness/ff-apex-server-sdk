@isTest
private class FFClientApiTest {
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

        Map<String, Object> params = new Map<String, Object>{
            'ffAuthenticationRequest' => ''
        };

        FFBaseCallout client;
        FFClientApi api;
        FFAuthenticationResponse response;
        FFAuthenticationResponse expectedResponse;
        String js = '';

        api = new FFClientApi(new FFBaseCallout(FFConfig.builder().build()));

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

        FFBaseCallout client;
        FFClientApi api;
        FFEvaluation response;
        FFEvaluation expectedResponse;
        String js = '';

        client = new FFBaseCallout(FFConfig.builder().build());
        api = new FFClientApi(client);

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

        FFBaseCallout client;
        FFClientApi api;
        List<FFEvaluation> response;
        List<FFEvaluation> expectedResponse;
        String js = '';

        client = new FFBaseCallout(FFConfig.builder().build());
        api = new FFClientApi(client);

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

        FFBaseCallout client;
        FFClientApi api;
        String js = '';

        client = new FFBaseCallout(FFConfig.builder().build());
        api = new FFClientApi(client);
        api.stream(params);
    }
}