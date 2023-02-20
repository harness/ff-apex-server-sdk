@isTest
public class FFFeatureEvaluatorTest {

    class MockVariationEvaluator implements FFFeatureVariationEvaluator {
        public String evaluateVariation(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
            return 'test-variation';
        }
    }

    class MockNullVariationEvaluator implements FFFeatureVariationEvaluator {
        public String evaluateVariation(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
            return null;
        }
    }

    @isTest
    public static void shouldReturnNullWhenConfigOrTargetNull() {
        FFFeatureEvaluator evaluator = new FFFeatureEvaluator(null);
        System.assertEquals(null, evaluator.evaluate(null, FFTarget.builder().build()));
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        System.assertEquals(null, evaluator.evaluate(config, FFTarget.builder().build()));
        config.variations = new List<FFModelsFeatures.Variation>();
        System.assertEquals(null, evaluator.evaluate(config, null));
    }

    @isTest
    public static void shouldReturnOffStateWhenOff() {
        FFFeatureEvaluator evaluator = new FFFeatureEvaluator(null);
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        config.state = 'off';
        config.offVariation = 'off-variation';

        FFModelsFeatures.Variation variation = new FFModelsFeatures.Variation();
        variation.identifier = 'off-variation';
        variation.name = 'test';
        config.variations = new List<FFModelsFeatures.Variation> { variation };

        System.assertEquals('test', evaluator.evaluate(config, FFTarget.builder().build()).name);
    }

    @isTest
    public static void shouldReturnNullWhenNoEvaluators() {
        FFFeatureEvaluator evaluator = new FFFeatureEvaluator(new List<FFFeatureVariationEvaluator>());
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        System.assertEquals(null, evaluator.evaluate(config, FFTarget.builder().build()));
    }

    @isTest
    public static void shouldReturnVariationFromEvaluatorResult() {
        FFFeatureEvaluator evaluator = new FFFeatureEvaluator(new List<FFFeatureVariationEvaluator>{ new MockVariationEvaluator() });
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.Variation variation = new FFModelsFeatures.Variation();
        variation.identifier = 'test-variation';
        variation.name = 'xyz';
        config.variations = new List<FFModelsFeatures.Variation> { variation };

        System.assertEquals('xyz', evaluator.evaluate(config, FFTarget.builder().build()).name);
    }

    @isTest
    public static void shouldReturnVariationFromEvaluatorResultAndIgnoreNullResultsBefore() {
        FFFeatureEvaluator evaluator = new FFFeatureEvaluator(
            new List<FFFeatureVariationEvaluator>{
                new MockNullVariationEvaluator(),
                new MockVariationEvaluator()
             }
            );
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.Variation variation = new FFModelsFeatures.Variation();
        variation.identifier = 'test-variation';
        variation.name = 'xyz';
        config.variations = new List<FFModelsFeatures.Variation> { variation };

        System.assertEquals('xyz', evaluator.evaluate(config, FFTarget.builder().build()).name);
    }
}