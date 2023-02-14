public class FFFeatureVariationRulesEvaluator implements FFFeatureVariationEvaluator {

    private final FFSegmentEvaluator segmentEvaluator;
    public FFFeatureVariationRulesEvaluator(FFSegmentEvaluator segmentEvaluator) {
        this.segmentEvaluator = segmentEvaluator;
    }

    public String evaluateVariation(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
       if(featureConfig.rules == null) return null;
       for(FFModelsFeatures.ServingRule servingRule: this.priorityOrderedRulesFrom(featureConfig)) {
            if(this.noClausesEvaluateToFalse(servingRule.clauses, target)) {
                if(servingRule.serve != null){
                    if(servingRule.serve.distribution != null) {
                        return FFDistributionEvaluator.variationFromDistribution(servingRule.serve);
                    }
                    if(servingRule.serve.variation != null) {
                        return servingRule.serve.variation;
                    }
                }
            }
       }
       return null;
    }

    private List<FFModelsFeatures.ServingRule> priorityOrderedRulesFrom(FFModelsFeatures.FeatureConfig  featureConfig) {
       List<FFModelsFeatures.ServingRule> rules = featureConfig.rules.clone();
       rules.sort();
       return rules;
    }

    private Boolean noClausesEvaluateToFalse(List<FFModelsFeatures.Clause> clauses, FFTarget target) {
        return !this.anyClauseEvaluatesToFalse(clauses, target);
    }

    private Boolean anyClauseEvaluatesToFalse(List<FFModelsFeatures.Clause> clauses, FFTarget target) {
        if(clauses != null) {
            for(FFModelsFeatures.Clause clause: clauses) {
                if(!FFClauseEvaluator.evaluateClause(clause, target, this.segmentEvaluator)){
                    return true;
                }
            }
        }
        return false;
    }
}