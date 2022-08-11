@isTest
private class OASClientApiTest {
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
        Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'oaSAuthenticationRequest' => ''
        };

        OASClient client;
        OASClientApi api;
        OASAuthenticationResponse response;
        OASAuthenticationResponse expectedResponse;
        String js = '';

        api = new OASClientApi(new OASClient(Config.builder().build()));

        js = JSON.serialize(OASAuthenticationResponse.getExample());
        res.setHeader('Content-Type', 'application/json');
        res.setBody(js);
        expectedResponse = OASAuthenticationResponse.getExample();
        response = (OASAuthenticationResponse) api.authenticate(params);
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
        Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'null',
            'feature' => 'null',
            'target' => 'null',
            'cluster' => 'null'
        };

        OASClient client;
        OASClientApi api;
        OASEvaluation response;
        OASEvaluation expectedResponse;
        String js = '';

        client = new OASClient(Config.builder().build());
        api = new OASClientApi(client);

        js = JSON.serialize(OASEvaluation.getExample());
        res.setHeader('Content-Type', 'application/json');
        res.setBody(js);
        expectedResponse = OASEvaluation.getExample();
        response = (OASEvaluation) api.getEvaluationByIdentifier(params);
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
        Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'null',
            'target' => 'null',
            'cluster' => 'null'
        };

        OASClient client;
        OASClientApi api;
        List<OASEvaluation> response;
        List<OASEvaluation> expectedResponse;
        String js = '';

        client = new OASClient(Config.builder().build());
        api = new OASClientApi(client);

        // js = JSON.serialize(List.getExample());
        // res.setHeader('Content-Type', 'application/json');
        // res.setBody(js);
        // expectedResponse = List.getExample();
        // response = (List<OASEvaluation>) api.getEvaluations(params);
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
        Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'apIKey' => 'null',
            'cluster' => 'null'
        };

        OASClient client;
        OASClientApi api;
        String js = '';

        client = new OASClient(Config.builder().build());
        api = new OASClientApi(client);
        api.stream(params);
    }
}