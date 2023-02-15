@isTest
private class FFPrerequisitesTest {

    class MockEvaluator implements FFEvaluator {
        public FFModelsFeatures.Variation returnThis;
        public MockEvaluator(FFModelsFeatures.Variation returnThis){
            this.returnThis = returnThis;
        }
        public FFModelsFeatures.Variation evaluate(FFModelsFeatures.FeatureConfig featureConfig, FFTarget target) {
            return returnThis;
        }
    }

    @isTest
    private static void shouldBeTrueWhenNoPrerequisites() {
        FFPrerequisites prerequisites = new FFPrerequisites(null, null);
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        System.assertEquals(true, prerequisites.passesPrerequisiteChecks(config, null));
        config.prerequisites = new List<FFModelsFeatures.Prerequisite>();
        System.assertEquals(true, prerequisites.passesPrerequisiteChecks(config, null));
    }

    @isTest
    private static void shouldBeTrueWhenPrerequisiteNotFound() {
        FFPrerequisites prerequisites = new FFPrerequisites(new List<FFModelsFeatures.FeatureConfig>(), null);
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.Prerequisite prerequisite = new FFModelsFeatures.Prerequisite();
        prerequisite.feature = 'testprereq';
        config.prerequisites = new List<FFModelsFeatures.Prerequisite>{ prerequisite };
        System.assertEquals(true, prerequisites.passesPrerequisiteChecks(config, null));
    }

    @isTest
    private static void shouldBeTrueWhenPrerequisiteFoundButEvaluatesToNull() {
        FFModelsFeatures.FeatureConfig existingFeature = new FFModelsFeatures.FeatureConfig();
        existingFeature.feature = 'testprereq';
        MockEvaluator evaluator = new MockEvaluator(null); //Evaluates to null
        FFPrerequisites prerequisites = new FFPrerequisites(new List<FFModelsFeatures.FeatureConfig>{ existingFeature }, evaluator);
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.Prerequisite prerequisite = new FFModelsFeatures.Prerequisite();
        prerequisite.feature = 'testprereq';
        config.prerequisites = new List<FFModelsFeatures.Prerequisite>{ prerequisite };
        System.assertEquals(true, prerequisites.passesPrerequisiteChecks(config, null));
    }

    @isTest
    private static void shouldBeFalseWhenPrerequisiteNotContainsVariation() {
        FFModelsFeatures.FeatureConfig existingFeature = new FFModelsFeatures.FeatureConfig();
        existingFeature.feature = 'testprereq';
        FFModelsFeatures.Variation variationEvaluated = new FFModelsFeatures.Variation();
        variationEvaluated.identifier = 'notMatching';
        MockEvaluator evaluator = new MockEvaluator(variationEvaluated);
        FFPrerequisites prerequisites = new FFPrerequisites(new List<FFModelsFeatures.FeatureConfig>{ existingFeature }, evaluator);
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.Prerequisite prerequisite = new FFModelsFeatures.Prerequisite();
        prerequisite.feature = 'testprereq';
        prerequisite.variations = new List<String>();
        config.prerequisites = new List<FFModelsFeatures.Prerequisite>{ prerequisite };
        System.assertEquals(false, prerequisites.passesPrerequisiteChecks(config, null));
    }

    @isTest
    private static void shouldBeTrueWhenPrerequisiteContainsVariation() {
        FFModelsFeatures.FeatureConfig existingFeature = new FFModelsFeatures.FeatureConfig();
        existingFeature.feature = 'testprereq';
        FFModelsFeatures.Variation variationEvaluated = new FFModelsFeatures.Variation();
        variationEvaluated.identifier = 'matching';
        MockEvaluator evaluator = new MockEvaluator(variationEvaluated);
        FFPrerequisites prerequisites = new FFPrerequisites(new List<FFModelsFeatures.FeatureConfig>{ existingFeature }, evaluator);
        FFModelsFeatures.FeatureConfig config = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.Prerequisite prerequisite = new FFModelsFeatures.Prerequisite();
        prerequisite.feature = 'testprereq';
        prerequisite.variations = new List<String> { 'matching' };
        config.prerequisites = new List<FFModelsFeatures.Prerequisite>{ prerequisite };
        System.assertEquals(true, prerequisites.passesPrerequisiteChecks(config, null));
    }
}