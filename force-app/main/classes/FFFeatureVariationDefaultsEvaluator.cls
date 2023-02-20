public class FFFeatureVariationDefaultsEvaluator implements FFFeatureVariationEvaluator {

    public String evaluateVariation(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
       return FFDistributionEvaluator.variationFromServe(featureConfig.defaultServe, target);
    }
}