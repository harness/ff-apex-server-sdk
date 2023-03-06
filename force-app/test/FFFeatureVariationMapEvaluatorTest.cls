@isTest
public class FFFeatureVariationMapEvaluatorTest {

    class MockNotInSegmentEvaluator implements FFSegmentEvaluator {
        public Boolean targetIncludedInSegment(List<string> segments, FFTarget target){
            return false;
        }
    }

    class MockInSegmentEvaluator implements FFSegmentEvaluator {
        public Boolean targetIncludedInSegment(List<string> segments, FFTarget target){
            return true;
        }
    }

    @isTest
    public static void shouldBeNullWhenVariationToTargetMapNull() {
        System.assertEquals(null, new FFFeatureVariationMapEvaluator(null).evaluateVariation(new FFModelsFeatures.FeatureConfig(), null));
    }

    @isTest
    public static void shouldBeVariationFromMapWhenIncludesTarget() {
        FFModelsFeatures.VariationMap variationMap = new FFModelsFeatures.VariationMap();
        FFModelsFeatures.TargetMap targetMap = new FFModelsFeatures.TargetMap();
        targetMap.identifier = 'test';
        variationMap.targets = new List<FFModelsFeatures.TargetMap>{ targetMap };
        variationMap.variation = 'test-variation';
        FFTarget target = FFTarget.builder().identifier('test').build();
        FFModelsFeatures.FeatureConfig feature = new FFModelsFeatures.FeatureConfig();
        feature.variationToTargetMap = new List<FFModelsFeatures.VariationMap>{ variationMap };
        String variation = new FFFeatureVariationMapEvaluator(null).evaluateVariation(feature, target);
        System.assertEquals('test-variation', variation);
    }

    @isTest
    public static void shouldBeNullWhenNotInMapAndNotInSegment() {
        FFModelsFeatures.VariationMap variationMap = new FFModelsFeatures.VariationMap();
        FFModelsFeatures.TargetMap targetMap = new FFModelsFeatures.TargetMap();
        targetMap.identifier = 'test';
        variationMap.targets = new List<FFModelsFeatures.TargetMap>{ targetMap };
        variationMap.variation = 'test-variation';
        FFTarget target = FFTarget.builder().identifier('not-test').build();
        FFModelsFeatures.FeatureConfig feature = new FFModelsFeatures.FeatureConfig();
        feature.variationToTargetMap = new List<FFModelsFeatures.VariationMap>{ variationMap };
        String variation = new FFFeatureVariationMapEvaluator(new MockNotInSegmentEvaluator()).evaluateVariation(feature, target);
        System.assertEquals(null, variation);
    }

    @isTest
    public static void shouldBeVariationFromMapWhenIncludedInSegment() {
        FFModelsFeatures.VariationMap variationMap = new FFModelsFeatures.VariationMap();
        FFModelsFeatures.TargetMap targetMap = new FFModelsFeatures.TargetMap();
        targetMap.identifier = 'test';
        variationMap.targets = new List<FFModelsFeatures.TargetMap>{ targetMap };
        variationMap.variation = 'test-variation';
        FFTarget target = FFTarget.builder().identifier('not-test').build();
        FFModelsFeatures.FeatureConfig feature = new FFModelsFeatures.FeatureConfig();
        feature.variationToTargetMap = new List<FFModelsFeatures.VariationMap>{ variationMap };
        String variation = new FFFeatureVariationMapEvaluator(new MockInSegmentEvaluator()).evaluateVariation(feature, target);
        System.assertEquals('test-variation', variation);
    }
}