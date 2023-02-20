@isTest
public class FFDistributionEvaluatorTest {
    @isTest
    public static void shouldReturnOneOfWeightedVariations() {
    FFModelsFeatures.Serve serve = new FFModelsFeatures.Serve();
    serve.distribution = new FFModelsFeatures.Distribution();
    serve.distribution.bucketBy = 'identifier';
    FFModelsFeatures.WeightedVariation variant1 = new FFModelsFeatures.WeightedVariation();
    variant1.weight = 10;
    variant1.variation = 'variant-1';
    FFModelsFeatures.WeightedVariation variant2 = new FFModelsFeatures.WeightedVariation();
    variant2.weight = 90;
    variant2.variation = 'variant-2';
    serve.distribution.variations = new List<FFModelsFeatures.WeightedVariation> { variant1, variant2 };
    List<String> variations = new List<String>();
    Integer count = 0;

    for(Integer i = 0;i<1000;i++) {
        variations.add(FFDistributionEvaluator.variationFromServe(serve, FFTarget.builder().identifier('test-' + i).build()));
    }
    Integer numOnes = 0;
    Integer numTwos = 0;
    for(String variation: variations) {
        if(variation == 'variant-1'){
            numOnes++;
        } else if(variation == 'variant-2') {
            numTwos++;
        }
    }

    System.assert(numOnes > 80 && numOnes < 120, 'Expected around 100 of variant 1 but was ' + numOnes);
    System.assert(numTwos > 700 && numTwos < 1100, 'Expected around 900 of variant 2 but was ' + numTwos);
    System.assert(numOnes + numTwos == 1000, 'Expected 1000 variants but some where other ' + (numOnes + numTwos));
    }
}