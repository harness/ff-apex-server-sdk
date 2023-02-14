public class FFPrerequisites {

    private final List<FFModelsFeatures.FeatureConfig> featureConfigs;
    private final FFEvaluator evaluator;

    public FFPrerequisites(List<FFModelsFeatures.FeatureConfig> featureConfigs, FFEvaluator evaluator) {
        this.featureConfigs = featureConfigs;
        this.evaluator = evaluator;
    }

    public Boolean passesPrerequisiteChecks(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
        if(featureConfig.prerequisites != null && featureConfig.prerequisites.size() > 0){
            for(FFModelsFeatures.Prerequisite prerequisite: featureConfig.prerequisites) {
                FFModelsFeatures.FeatureConfig prereqFeatureConfig = this.getFeatureConfig(prerequisite.feature);
                if(prereqFeatureConfig == null) return true;
                FFModelsFeatures.Variation variation = this.evaluator.evaluate(prereqFeatureConfig, target);
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

    private FFModelsFeatures.FeatureConfig getFeatureConfig(String identifier) {
        for(FFModelsFeatures.FeatureConfig featureConfig: this.featureConfigs) {
            if(featureConfig.feature == identifier) return featureConfig;
        }
        return null;
    }
    
}