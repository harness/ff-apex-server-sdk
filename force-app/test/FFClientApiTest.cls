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

    @isTest
    private static void getFeatureConfigsTest() {
        List<FFModelsFeatures.FeatureConfig> mockResponse = new List<FFModelsFeatures.FeatureConfig>();
        FFModelsFeatures.FeatureConfig feature = new FFModelsFeatures.FeatureConfig();
        feature.kind = 'string';
        feature.offVariation = 'off';
        feature.version = 5;
        feature.project = 'p';
        feature.prerequisites = new List<FFModelsFeatures.Prerequisite>();
        String serielized = JSON.serialize(mockResponse);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(serielized);
        res.setStatusCode(200);
        res.setStatus('OK');

        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'test',
            'cluster' => 'test'
        };
        FFBaseCallout client = new FFBaseCallout('test', 'test');
        FFClientApi api = new FFClientApi(client);
        String actualResponse = JSON.serialize(api.getFeatureConfigs(params));
        System.assertEquals(serielized, actualResponse);
    }

    @isTest
    private static void getTargetSegmentsTest() {
        List<FFModelsFeatures.TargetSegment> mockResponse = new List<FFModelsFeatures.TargetSegment>();
        FFModelsFeatures.TargetSegment segment = new FFModelsFeatures.TargetSegment();
        FFModelsFeatures.Tag tag = new FFModelsFeatures.Tag();
        tag.name = 'a';
        tag.value = 'b';
        segment.tags = new List<FFModelsFeatures.Tag>{ tag };
        segment.createdAt = 1234;
        segment.environment = 'test';
        segment.excluded = new List<FFTarget>();
        segment.included = new List<FFTarget>();
        segment.identifier = '1234';
        segment.name = 'test';
        segment.modifiedAt = 1234;
        segment.version = 5;
        String serielized = JSON.serialize(mockResponse);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(serielized);
        res.setStatusCode(200);
        res.setStatus('OK');

        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'test',
            'cluster' => 'test'
        };
        FFBaseCallout client = new FFBaseCallout('test', 'test');
        FFClientApi api = new FFClientApi(client);
        String actualResponse = JSON.serialize(api.getTargetSegments(params));
        System.assertEquals(serielized, actualResponse);
    }
}