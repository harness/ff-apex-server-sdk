public class FFPrerequisites {

    private final List<FFFeatureConfig> featureConfigs;
    private final FFEvaluator evaluator;

    public FFPrerequisites(List<FFFeatureConfig> featureConfigs, FFEvaluator evaluator) {
        this.featureConfigs = featureConfigs;
        this.evaluator = evaluator;
    }

    public Boolean passesPrerequisiteChecks(FFFeatureConfig featureConfig, FFTarget target) {
        if(featureConfig.prerequisites != null && featureConfig.prerequisites.size() > 0){
            for(FFFeaturePrerequisite prerequisite: featureConfig.prerequisites) {
                FFFeatureConfig prereqFeatureConfig = this.getFeatureConfig(prerequisite.feature);
                if(prereqFeatureConfig == null) return true;
                FFFeatureVariation variation = this.evaluator.evaluate(prereqFeatureConfig, target);
                if(variation == null) return true;
                if(!prerequisite.variations.contains(variation.identifier)){
                    return false;
                }
                if(!passesPrerequisiteChecks(prereqFeatureConfig, target)){
                    return false;
                }
            }
        }
        return true;
    }

    private FFFeatureConfig getFeatureConfig(String identifier) {
        for(FFFeatureConfig featureConfig: this.featureConfigs) {
            if(featureConfig.feature == identifier) return featureConfig;
        }
        return null;
    }
    
}