@isTest
private class FFClientApiTest {

    @isTest
    private static void authenticateTest() {
        FFModels.AuthenticationResponse mockResponse = new FFModels.AuthenticationResponse();
        mockResponse.authToken = 'testToken';

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(mockResponse));
        res.setStatusCode(200);
        res.setStatus('OK');

        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        FFModels.AuthenticationRequest req = new FFModels.AuthenticationRequest();
        Map<String, Object> params = new Map<String, Object>{
            'ffAuthenticationRequest' => req
        };
        FFBaseCallout client = new FFBaseCallout('test', 'test');
        FFClientApi api = new FFClientApi(client);
        FFModels.AuthenticationResponse actualResponse = (FFModels.AuthenticationResponse) api.authenticate(params);
        System.assertEquals(mockResponse.authToken, actualResponse.authToken);
    }

    // /**
    //  * Get feature evaluations for target
    //  *
    //  * 
    //  */
    // @isTest
    // private static void getEvaluationByIdentifierTest() {
    //     HttpResponse res = new HttpResponse();
    //     res.setStatusCode(200);
    //     res.setStatus('OK');
    //     Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

    //     Map<String, Object> params = new Map<String, Object>{
    //         'environmentUUID' => 'null',
    //         'feature' => 'null',
    //         'target' => 'null',
    //         'cluster' => 'null'
    //     };

    //     FFBaseCallout client = new FFBaseCallout('test', 'test');
    //     FFClientApi api = new FFClientApi(client);

    //     FFEvaluation response;
    //     FFEvaluation expectedResponse;
    //     String js = '';

    //     js = JSON.serialize(FFEvaluation.getExample());
    //     res.setHeader('Content-Type', 'application/json');
    //     res.setBody(js);
    //     expectedResponse = FFEvaluation.getExample();
    //     response = (FFEvaluation) api.getEvaluationByIdentifier(params);
    //     System.assertEquals(expectedResponse, response);
    // }

    // /**
    //  * Get feature evaluations for target
    //  *
    //  * 
    //  */
    // @isTest
    // private static void getEvaluationsTest() {
    //     HttpResponse res = new HttpResponse();
    //     res.setStatusCode(200);
    //     res.setStatus('OK');
    //     Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

    //     Map<String, Object> params = new Map<String, Object>{
    //         'environmentUUID' => 'null',
    //         'target' => 'null',
    //         'cluster' => 'null'
    //     };

    //     FFBaseCallout client = new FFBaseCallout('test', 'test');
    //     FFClientApi api = new FFClientApi(client);
    //     List<FFEvaluation> response;
    //     List<FFEvaluation> expectedResponse;
    //     String js = '';

    //     // js = JSON.serialize(List.getExample());
    //     // res.setHeader('Content-Type', 'application/json');
    //     // res.setBody(js);
    //     // expectedResponse = List.getExample();
    //     // response = (List<FFEvaluation>) api.getEvaluations(params);
    //     // System.assertEquals(expectedResponse, response);
    // }

    // /**
    //  * Stream endpoint.
    //  *
    //  * 
    //  */
    // @isTest
    // private static void streamTest() {
    //     HttpResponse res = new HttpResponse();
    //     res.setStatusCode(200);
    //     res.setStatus('OK');
    //     Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

    //     Map<String, Object> params = new Map<String, Object>{
    //         'apIKey' => 'null',
    //         'cluster' => 'null'
    //     };

    //     String js = '';

    //     FFBaseCallout client = new FFBaseCallout('test', 'test');
    //     FFClientApi api = new FFClientApi(client);
    //     api.stream(params);
    // }
}