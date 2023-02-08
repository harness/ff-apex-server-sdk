public class FFFeatureEvaluator implements FFEvaluator {

    private final List<FFFeatureVariationEvaluator> variationEvaluators;

    public FFFeatureEvaluator(List<FFFeatureVariationEvaluator> variationEvaluators) {
       this.variationEvaluators = variationEvaluators;
    }

    public FFFeatureVariation evaluate(FFFeatureConfig featureConfig, FFTarget target) {
       if(featureConfig == null || target == null || featureConfig.variations == null) return null;
       String evaluatedVariation = this.evaluateVariation(featureConfig, target);
       if(evaluatedVariation != null) {
           for(FFFeatureVariation variation: featureConfig.variations) {
                if(variation.identifier == evaluatedVariation) {
                    return variation;
                }
           }
       }
       return null;
    }

    private String evaluateVariation(FFFeatureConfig featureConfig, FFTarget target) {
        if(featureConfig.state == 'off') {
            return featureConfig.offVariation;
        }
        for(Integer i = 0; i < this.variationEvaluators.size(); i++) {
            String variation = this.variationEvaluators[i].evaluateVariation(featureConfig, target);
            if(variation != null) return variation;
        }
        return null;
     }

     public static FFFeatureEvaluator defaultEvaluators(FFSegmentEvaluator segmentEvaluator){
        return new FFFeatureEvaluator(new List<FFFeatureVariationEvaluator> {
            new FFFeatureVariationMapEvaluator(segmentEvaluator),
            new FFFeatureVariationRulesEvaluator(segmentEvaluator),
            new FFFeatureVariationDefaultsEvaluator()
        });
     }
}