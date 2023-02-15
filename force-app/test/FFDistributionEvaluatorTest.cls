@isTest
public class FFDistributionEvaluatorTest {
    @isTest
    public static void shouldReturnOneOfWeightedVariations() {
        FFModelsFeatures.Serve serve = new FFModelsFeatures.Serve();
        serve.distribution = new FFModelsFeatures.Distribution();
        FFModelsFeatures.WeightedVariation variant1 = new FFModelsFeatures.WeightedVariation();
        variant1.weight = 10;
        variant1.variation = 'variant-1';
        FFModelsFeatures.WeightedVariation variant2 = new FFModelsFeatures.WeightedVariation();
        variant2.weight = 90;
        variant2.variation = 'variant-2';
        serve.distribution.variations = new List<FFModelsFeatures.WeightedVariation> { variant1, variant2 };
        List<String> variations = new List<String>();
        Integer count = 0;
        while(count < 1000) {
            variations.add(FFDistributionEvaluator.variationFromServe(serve));
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