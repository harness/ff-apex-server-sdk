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
            'ffMetrics' => new FFModelsEvents.Metrics()
        };

        FFBaseCallout client = new FFBaseCallout(null, '');
        FFMetricsApi api = new FFMetricsApi(client);

        api.postMetrics(params);
        client = new FFBaseCallout(null, '');
        api = new FFMetricsApi(client);
        api.postMetrics(params);
    }
}