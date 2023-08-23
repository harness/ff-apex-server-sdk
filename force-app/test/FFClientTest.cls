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
            if(request.getEndpoint() == '/client/env/{environmentUUID}/feature-configs') {
                return httpResponse(features);
            } else return httpResponse(targets);
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

    private static FFClientApi mockClientApi(List<FFModelsFeatures.FeatureConfig> features, List<FFModelsFeatures.TargetSegment> targets) {
        Test.setMock(HttpCalloutMock.class, new Responder(features, targets));
        Map<String, Object> params = new Map<String, Object>{
            'environmentUUID' => 'test',
            'cluster' => 'test'
        };
        return new FFClientApi(new FFBaseCallout('test', 'test'));
    }

    @isTest
    private static void shouldUpdateCacheWithLatestFromHttpCalls() {
        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        List<FFModelsFeatures.TargetSegment> targets = new List<FFModelsFeatures.TargetSegment>();
        FFConfig config = FFConfig.builder().cache(new FFMockCache()).build();
        FFClient client = new FFClient(mockClientApi(features, targets), null, config, 'test', 'test');
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

        FFClient client = new FFClient(null, null, config, 'test', 'test');
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

        FFClient client = new FFClient(null, null, config, 'test', 'test');
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

        FFClient client = new FFClient(null, null, config, 'test', 'test');
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

        FFClient client = new FFClient(null, null, config, 'test', 'test');
        FFTarget target = FFTarget.builder().identifier('test').anonymous(false).attributes(null).build();
        System.assertEquals(false, client.boolVariation('test-feature', target, true));
    }
}