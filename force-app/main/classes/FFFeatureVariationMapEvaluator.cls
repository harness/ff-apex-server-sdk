public class FFFeatureVariationMapEvaluator implements FFFeatureVariationEvaluator {

    private final FFSegmentEvaluator segmentEvaluator;
    public FFFeatureVariationMapEvaluator(FFSegmentEvaluator segmentEvaluator) {
        this.segmentEvaluator = segmentEvaluator;
    }

    public String evaluateVariation(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
       if(featureConfig.variationToTargetMap == null) return null;
       for(FFModelsFeatures.VariationMap variationMap: featureConfig.variationToTargetMap) {
           if(this.hasTargetIn(variationMap.targets, target.identifier)) {
               return variationMap.variation;
           }
           if(this.segmentEvaluator.targetIncludedInSegment(variationMap.targetSegments, target)){
               return variationMap.variation;
           }
       }
       return null;
    }

    private Boolean hasTargetIn(List<FFModelsFeatures.TargetMap> variationMapTargets, String targetIdentifier) {
        for(FFModelsFeatures.TargetMap target: variationMapTargets) {
            if(target != null && target.identifier == targetIdentifier) {
                return true;
            }
        }
        return false;
    }
}