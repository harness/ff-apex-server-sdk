@isTest
public class FFFeatureVariationDefaultsEvaluatorTest {
    @isTest
    public static void shouldReturnDefaultVariation() {
        FFFeatureVariationEvaluator evaluator = new FFFeatureVariationDefaultsEvaluator();
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        config.defaultServe = new FFModelsFeatures.Serve();
        config.defaultServe.variation = 'test-variant';
        String variation = evaluator.evaluateVariation(config, null);
        System.assertEquals(variation, 'test-variant');
    }
}