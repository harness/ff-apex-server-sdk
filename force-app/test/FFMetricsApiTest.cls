@isTest
private class FFMetricsApiTest {
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
        Test.setMock(HttpCalloutMock.class, new FFResponseMock(res));

        Map<String, Object> params = new Map<String, Object>{
            'environment' => 'null',
            'cluster' => 'null',
            'ffMetrics' => new FFMetrics()
        };

        FFBaseCallout client;
        FFMetricsApi api;
        String js = '';

        client = new FFBaseCallout(FFConfig.builder().build());
        api = new FFMetricsApi(client);
        ((FFBase.ApiKeyAuth)client.getAuthentication('ApiKeyAuth')).setApiKey('foo-bar-api-key');

        api.postMetrics(params);
        client = new FFBaseCallout(FFConfig.builder().build());
        api = new FFMetricsApi(client);
        api.postMetrics(params);
    }
}