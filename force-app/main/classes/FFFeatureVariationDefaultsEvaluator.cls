public class FFFeatureVariationDefaultsEvaluator implements FFFeatureVariationEvaluator {

    public String evaluateVariation(FFFeatureConfig featureConfig, FFTarget target) {
       FFFeatureServe defaultServe = featureConfig.defaultServe;
       String distributedVariation = FFDistributionEvaluator.variationFromDistribution(defaultServe);
       if(distributedVariation != null) return distributedVariation;
       return defaultServe.variation;
    }
}