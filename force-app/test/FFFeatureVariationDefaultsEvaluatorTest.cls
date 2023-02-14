@isTest
public class FFFeatureVariationDefaultsEvaluatorTest {
    @isTest
    public static void shouldReturnDefaultVariation() {
        FFFeatureVariationEvaluator evaluator = new FFFeatureVariationDefaultsEvaluator();
        FFFeatureConfig config = new FFFeatureConfig();
        config.defaultServe = new FFFeatureServe();
        config.defaultServe.variation = 'test-variant';
        String variation = evaluator.evaluateVariation(config, null);
        System.assertEquals(variation, 'test-variant');
    }
    @isTest
    public static void shouldReturnOneOfWeightedVariations() {
        FFFeatureVariationEvaluator evaluator = new FFFeatureVariationDefaultsEvaluator();
        FFFeatureConfig config = new FFFeatureConfig();
        config.defaultServe = new FFFeatureServe();
        config.defaultServe.distribution = new FFFeatureDistribution();
        FFFeatureWeightedVariation variant1 = new FFFeatureWeightedVariation();
        variant1.weight = 10;
        variant1.variation = 'variant-1';
        FFFeatureWeightedVariation variant2 = new FFFeatureWeightedVariation();
        variant2.weight = 90;
        variant2.variation = 'variant-2';
        config.defaultServe.distribution.variations = new List<FFFeatureWeightedVariation> { variant1, variant2 };
        List<String> variations = new List<String>();
        Integer count = 0;
        while(count < 1000) {
            variations.add(evaluator.evaluateVariation(config, null));
            count++;
        }
        Integer numOnes = 0;
        for(String variation: variations) {
            if(variation == 'variant-1'){
                numOnes++;
            }
        }
        System.assert(numOnes > 80 && numOnes < 120, 'Expected around 100 of variant 1 but was ' + numOnes);
    }
}