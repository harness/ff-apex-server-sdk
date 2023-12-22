@isTest
private class FFClientTest {

    public class Responder implements HttpCalloutMock {
        public List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        public List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();

        public Responder(List<FFModelsFeatures.FeatureConfig> features, List<FFModelsFeatures.TargetSegment> targets) {
            this.features = features;
            this.targets = targets;
        }
    
        public HttpResponse respond(HttpRequest request) {
            String endpoint = request.getEndpoint();
    
            if (endpoint.contains('/client/env/{environmentUUID}/feature-configs')) {
                return httpResponse(features);
            } else return httpResponse(targets);
            
        }
    }

    private class MockFFAuthService implements FFAuthService {
        private FFModels.AuthInfo mockAuthInfo;
        private FFModels.LastAuthTime mockLastAuthTime;
        public Boolean authenticateCalled = false;
    
        public MockFFAuthService(FFModels.AuthInfo mockAuthInfo) {
            this.mockAuthInfo = mockAuthInfo;
        }
    
        public FFModels.AuthInfo authenticate(Boolean force) {
            authenticateCalled = true;
            return mockAuthInfo;
        }
    
        public FFModels.LastAuthTime getLastAuthTime() {
            return mockLastAuthTime;
        }
    
        public void setLastAuthTime(FFModels.LastAuthTime lastAuthTime) {
            this.mockLastAuthTime = lastAuthTime;
        }
    }
    

    private static HttpResponse httpResponse(Object content) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(content));
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }

    private static FFClientApi mockApi(List<FFModelsFeatures.FeatureConfig> features, List<FFModelsFeatures.TargetSegment> targets) {
        Test.setMock(HttpCalloutMock.class, new Responder(features, targets));
        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'test',
            'cluster' => 'test'
        };
        return new FFClientApi(new FFBaseCallout('test', 'test'));
    }

    private static FFMetricsApi mockMetricsApi(List<FFModelsFeatures.FeatureConfig> features, List<FFModelsFeatures.TargetSegment> targets) {
        Test.setMock(HttpCalloutMock.class, new Responder(features, targets));
        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'test',
            'cluster' => 'test'
        };
        return new FFMetricsApi(new FFBaseCallout('test', 'test'));
    }

    @isTest
    private static void shouldUpdateCacheWithLatestFromHttpCalls() {
        FFModels.AuthInfo mockAuthInfo = new FFModels.AuthInfo('mockToken', 'envUUID', 'cluster');
        MockFFAuthService mockAuthService = new MockFFAuthService(mockAuthInfo);
        
        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();


        FFConfig config = FFConfig.builder().cache(new FFMockCache()).build();
        FFClient client = new FFClient(null, mockApi(features, targets), null, config, 'test', 'test');
        System.assertEquals(null, config.cache.getFeatures());
        System.assertEquals(null, config.cache.getSegments());

        client.updateCache();
        System.assertEquals(0, ((List<FFModelsFeatures.FeatureConfig>)config.cache.getFeatures()).size());
        System.assertEquals(0, ((List<FFModelsFeatures.TargetSegment>)config.cache.getSegments()).size());
    }

    @isTest
    private static void shouldReturnDefaultWhenKindDoesntMatch() {
        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();
        
        FFModelsFeatures.FeatureConfig testFeature = new FFModelsFeatures.FeatureConfig();
        testFeature.feature = 'test-feature';
        testFeature.kind = 'not-a-kind';
        features.add(testFeature);
        
        FFCache cache = new FFMockCache();
        cache.putFeatures(features, 1);
        cache.putSegments(targets, 1);
        FFConfig config = FFConfig.builder().cache(cache).build();

        FFClient client = new FFClient(null, null, null, config, 'test', 'test');
        FFTarget target = FFTarget.builder().identifier('test').build();
        System.assertEquals(false, client.boolVariation('test-feature', target, false));
        System.assertEquals(new Map<String, Object>(), client.jsonVariation('test-feature', target, new Map<String, Object>(), Map<String, Object>.class));
        System.assertEquals('test', client.stringVariation('test-feature', target, 'test'));
        System.assertEquals(100, client.numberVariation('test-feature', target, 100));
    }

    @isTest
    private static void shouldReturnDefaultServe() {
        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();
        
        FFModelsFeatures.FeatureConfig testFeature = new FFModelsFeatures.FeatureConfig();
        testFeature.feature = 'test-feature';
        testFeature.kind = 'boolean';
        testFeature.variations = new List<FFModelsFeatures.Variation>();
        FFModelsFeatures.Variation variation = new FFModelsFeatures.Variation();
        variation.identifier = 'test';
        variation.value = 'true';
        testFeature.variations.add(variation);
        features.add(testFeature);
        testFeature.defaultServe = new FFModelsFeatures.Serve();
        testFeature.defaultServe.variation = 'test';
        FFCache cache = new FFMockCache();
        cache.putFeatures(features, 1);
        cache.putSegments(targets, 1);
        FFConfig config = FFConfig.builder().cache(cache).evalExpireAfter(1).authExpireAfter(1).baseUrl('').eventsUrl('').featureConfigTimeToLive(1).build();

        FFClient client = new FFClient(null, null, null, config, 'test', 'test');
        FFTarget target = new FFTarget('test', '');
        target.attributes = new Map<String, Object> { 'a' => 'b' };
        System.assertEquals(true, client.boolVariation('test-feature', target, false));
    }

    private static void verifyKind(String kind, String value, Object expected, Type type) {
        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();
        
        FFModelsFeatures.FeatureConfig testFeature = new FFModelsFeatures.FeatureConfig();
        testFeature.feature = 'test-feature';
        testFeature.kind = kind;
        testFeature.variations = new List<FFModelsFeatures.Variation>();
        FFModelsFeatures.Variation variation = new FFModelsFeatures.Variation();
        variation.identifier = 'test';
        variation.value = value;
        testFeature.variations.add(variation);
        features.add(testFeature);
        testFeature.defaultServe = new FFModelsFeatures.Serve();
        testFeature.defaultServe.variation = 'test';
        FFCache cache = new FFMockCache();
        cache.putFeatures(features, 1);
        cache.putSegments(targets, 1);
        FFConfig config = FFConfig.builder().cache(cache).build();

        FFClient client = new FFClient(null, null, null, config, 'test', 'test');
        FFTarget target = new FFTarget('test', '');
        target.attributes = new Map<String, Object> { 'a' => 'b' };
        switch on kind {
            when 'boolean' {
                System.assertEquals(expected, client.boolVariation('test-feature', target, false));
            }
            when 'int' {
                System.assertEquals(expected, client.numberVariation('test-feature', target, 0));
            }
            when 'string' {
                System.assertEquals(expected, client.stringVariation('test-feature', target, ''));
            }
            when 'json' {
                System.assertEquals(expected, client.jsonVariation('test-feature', target, null, type));
            }
        }
    }

    @isTest
    private static void shouldReturnBooleanVariation() {
        verifyKind('boolean', 'true', true, null);
    }
    @isTest
    private static void shouldReturnNumberVariation() {
        verifyKind('int', '55', 55, null);
    }
    @isTest
    private static void shouldReturnStringVariation() {
        verifyKind('string', 'xyz', 'xyz', null);
    }

    public class FakeJSONObj{
        public String content { get; set; }
        public Boolean equals(Object b) {
            return ((FakeJSONObj)b).content == content;
        }
    }

    @isTest
    private static void shouldReturnJsonVariation() {
        FakeJSONObj example = new FakeJSONObj();
        example.content = 'test';
        String content = JSON.serialize(example);
        verifyKind('json', content, example, FakeJSONObj.class);
    }

    @isTest
    private static void shouldReturnOffVariantWhenPrerequisiteCheckFails() {
        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();
        
        FFModelsFeatures.FeatureConfig testFeature = new FFModelsFeatures.FeatureConfig();
        testFeature.feature = 'test-feature';
        testFeature.kind = 'boolean';
        testFeature.offVariation = 'off';
        FFModelsFeatures.Prerequisite pre = new FFModelsFeatures.Prerequisite();
        pre.feature = 'prereq';
        pre.variations = new List<String>();
        testFeature.prerequisites = new List<FFModelsFeatures.Prerequisite>{ pre };
        features.add(testFeature);
        FFModelsFeatures.Variation offVar = new FFModelsFeatures.Variation();
        offVar.identifier = 'off';
        offVar.value = 'false';
        testFeature.variations = new List<FFModelsFeatures.Variation>{ offVar };

        FFModelsFeatures.FeatureConfig preFeature = new FFModelsFeatures.FeatureConfig();
        preFeature.feature = 'prereq';
        preFeature.kind = 'boolean';
        preFeature.defaultServe = new FFModelsFeatures.Serve();
        preFeature.defaultServe.variation = 'preVar';
        FFModelsFeatures.Variation preVar = new FFModelsFeatures.Variation();
        preVar.identifier = 'preVar';
        preVar.value = 'true';
        preFeature.variations = new List<FFModelsFeatures.Variation>{ preVar };
        features.add(preFeature);
        
        FFCache cache = new FFMockCache();
        cache.putFeatures(features, 1);
        cache.putSegments(targets, 1);
        FFConfig config = FFConfig.builder().cache(cache).metricsEnabled().build();

        FFClient client = new FFClient(null, null, null, config, 'test', 'test');
        FFTarget target = FFTarget.builder().identifier('test').anonymous(false).attributes(null).build();
        System.assertEquals(false, client.boolVariation('test-feature', target, true));
    }

    // @isTest
    // private static void shouldReauthenticateWhenTokenIsAboutToExpire() {
    //     FFModels.AuthInfo mockAuthInfo = new FFModels.AuthInfo('mockToken', 'envUUID', 'cluster');
    //     MockFFAuthService mockAuthService = new MockFFAuthService(mockAuthInfo);

    //     // Set the last authentication time to be just over 23 hours ago
    //     Long pastTimeMillis = Datetime.now().addSeconds(-((23 * 60 * 60) + 1)).getTime();
    //     mockAuthService.setLastAuthTime(new FFModels.LastAuthTime(String.valueOf(pastTimeMillis)));

    //     FFConfig config = FFConfig.builder().authExpireAfter(24 * 60 * 60).cache(new FFMockCache()).build();
    //     FFClient client = new FFClient(mockAuthService, null, null, config, 'test', 'test');

    //     new FFPoller(new FFClient.CacheUpdator(client))
    //     .staticDelay(1)
    //     .untilTrue(new FFClientBuilder.AlwaysFalse())
    //     .execute();
    


    //     // Verify that reauthentication was triggered
    //     System.assertEquals(true, mockAuthService.authenticateCalled, 'Reauthentication was not triggered as expected');
    // }

    @isTest
    private static void shouldReauthenticateWhenTokenIsAboutToExpire() {
        // Create mock authentication information
        FFModels.AuthInfo mockAuthInfo = new FFModels.AuthInfo('mockToken', 'envUUID', 'cluster');
        MockFFAuthService mockAuthService = new MockFFAuthService(mockAuthInfo);

        // Set the last authentication time to be just over 23 hours ago
        // This simulates the condition where the token is near its expiration
        Long pastTimeMillis = Datetime.now().addSeconds(-((23 * 60 * 60) + 1)).getTime();
        mockAuthService.setLastAuthTime(new FFModels.LastAuthTime(String.valueOf(pastTimeMillis)));

        // Create the FFClient configuration with a specified expiration interval
        FFConfig config = FFConfig.builder().authExpireAfter(24 * 60 * 60) // Token expires after 24 hours
                                    .cache(new FFMockCache()).build();



        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();
        // Instantiate FFClient with the mock auth service
        FFClient client = new FFClient(mockAuthService, mockApi(features, targets), mockMetricsApi(features, targets), config, 'test', 'test');

        // Instantiate the CacheUpdator with the FFClient instance
        FFClient.CacheUpdator cacheUpdator = new FFClient.CacheUpdator(client);

        // Directly invoke the logic that would be triggered by the poller
        // This should check the last authentication time and decide whether to reauthenticate
        cacheUpdator.call(null, null);

        // Verify that reauthentication was triggered due to the token being near expiration
        System.assertEquals(true, mockAuthService.authenticateCalled, 'Reauthentication was not triggered as expected');
    }


}