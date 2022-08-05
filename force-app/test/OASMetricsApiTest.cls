@isTest
private class OASMetricsApiTest {
    /**
     * Send metrics to the Analytics server.
     *
     * Send metrics to Analytics server
     */
    @isTest
    private static void postMetricsTest() {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        Test.setMock(HttpCalloutMock.class, new OASResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environment' => 'null',
            'cluster' => 'null',
            'oaSMetrics' => ''
        };

        OASClient client;
        OASMetricsApi api;
        String js = '';

        client = new OASClient(Config.builder().build());
        api = new OASMetricsApi(client);
        ((OAS.ApiKeyAuth)client.getAuthentication('ApiKeyAuth')).setApiKey('foo-bar-api-key');

        api.postMetrics(params);
        client = new OASClient(Config.builder().build());
        api = new OASMetricsApi(client);
        api.postMetrics(params);
    }
}