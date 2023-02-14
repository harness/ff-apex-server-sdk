public class FFFeatureVariationDefaultsEvaluator implements FFFeatureVariationEvaluator {

    public String evaluateVariation(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
       FFModelsFeatures.Serve defaultServe = featureConfig.defaultServe;
       String distributedVariation = FFDistributionEvaluator.variationFromDistribution(defaultServe);
       if(distributedVariation != null) return distributedVariation;
       return defaultServe.variation;
    }
}