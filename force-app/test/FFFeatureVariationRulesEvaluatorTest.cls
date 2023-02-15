@isTest
public class FFFeatureVariationRulesEvaluatorTest {
    @isTest
    public static void shouldBeNullWhenRulesAreNull() {
        FFFeatureVariationRulesEvaluator evaluator = new FFFeatureVariationRulesEvaluator(null);
        FFModelsFeatures.FeatureConfig featureConfig = new FFModelsFeatures.FeatureConfig();
        System.assertEquals(null, evaluator.evaluateVariation(featureConfig, null));
    }

    @isTest
    public static void shouldServeWhenNoClause() {
        FFFeatureVariationRulesEvaluator evaluator = new FFFeatureVariationRulesEvaluator(null);
        FFModelsFeatures.FeatureConfig featureConfig = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.ServingRule ruleWithNoClauses = new FFModelsFeatures.ServingRule();
        ruleWithNoClauses.serve = new FFModelsFeatures.Serve();
        ruleWithNoClauses.serve.variation = 'test';
        featureConfig.rules = new List<FFModelsFeatures.ServingRule>{ ruleWithNoClauses };
        System.assertEquals('test', evaluator.evaluateVariation(featureConfig, null));
    }

    @isTest
    public static void shouldServeHighestPriority() {
        FFFeatureVariationRulesEvaluator evaluator = new FFFeatureVariationRulesEvaluator(null);
        FFModelsFeatures.FeatureConfig featureConfig = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.ServingRule ruleWithNoClauses = new FFModelsFeatures.ServingRule();
        ruleWithNoClauses.serve = new FFModelsFeatures.Serve();
        ruleWithNoClauses.serve.variation = 'test';
        ruleWithNoClauses.priority = 5;

        FFModelsFeatures.ServingRule ruleWithNoClauses2 = new FFModelsFeatures.ServingRule();
        ruleWithNoClauses2.serve = new FFModelsFeatures.Serve();
        ruleWithNoClauses2.serve.variation = 'test2';
        ruleWithNoClauses2.priority = 0;
        featureConfig.rules = new List<FFModelsFeatures.ServingRule>{ ruleWithNoClauses, ruleWithNoClauses2 };
        System.assertEquals('test2', evaluator.evaluateVariation(featureConfig, null));
    }

    @isTest
    public static void shouldServeOnlyRuleWithNoFailingClauses() {
        FFFeatureVariationRulesEvaluator evaluator = new FFFeatureVariationRulesEvaluator(null);
        FFModelsFeatures.FeatureConfig featureConfig = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.ServingRule ruleWithNoClauses = new FFModelsFeatures.ServingRule();
        ruleWithNoClauses.serve = new FFModelsFeatures.Serve();
        ruleWithNoClauses.serve.variation = 'test';
        ruleWithNoClauses.priority = 5;

        FFModelsFeatures.ServingRule ruleWithFailingClause = new FFModelsFeatures.ServingRule();
        ruleWithFailingClause.serve = new FFModelsFeatures.Serve();
        ruleWithFailingClause.serve.variation = 'test2';
        ruleWithFailingClause.priority = 0;
        FFModelsFeatures.Clause clause = new FFModelsFeatures.Clause();
        clause.attribute = 'identifier';
        clause.op = 'equals';
        clause.values = new List<String>{ 'xyz' };
        ruleWithFailingClause.clauses = new List<FFModelsFeatures.Clause>{ clause };
        featureConfig.rules = new List<FFModelsFeatures.ServingRule>{ ruleWithNoClauses, ruleWithFailingClause };
        System.assertEquals('test', evaluator.evaluateVariation(featureConfig, FFTarget.builder().identifier('abc').build()));
    }

    @isTest
    public static void shouldServeHigherPriorityRuleWhenAllMatch() {
        FFFeatureVariationRulesEvaluator evaluator = new FFFeatureVariationRulesEvaluator(null);
        FFModelsFeatures.FeatureConfig featureConfig = new FFModelsFeatures.FeatureConfig();
        FFModelsFeatures.ServingRule lowerPriorityRule = new FFModelsFeatures.ServingRule();
        lowerPriorityRule.serve = new FFModelsFeatures.Serve();
        lowerPriorityRule.serve.variation = 'test';
        lowerPriorityRule.priority = 5;
        FFModelsFeatures.Clause clause = new FFModelsFeatures.Clause();
        clause.attribute = 'identifier';
        clause.op = 'ends_with';
        clause.values = new List<String>{ 'bc' };
        lowerPriorityRule.clauses = new List<FFModelsFeatures.Clause>{ clause };

        FFModelsFeatures.ServingRule higherPriorityRule = new FFModelsFeatures.ServingRule();
        higherPriorityRule.serve = new FFModelsFeatures.Serve();
        higherPriorityRule.serve.variation = 'test2';
        higherPriorityRule.priority = 0;
        FFModelsFeatures.Clause clause2 = new FFModelsFeatures.Clause();
        clause2.attribute = 'identifier';
        clause2.op = 'starts_with';
        clause2.values = new List<String>{ 'ab' };
        higherPriorityRule.clauses = new List<FFModelsFeatures.Clause>{ clause2 };
        featureConfig.rules = new List<FFModelsFeatures.ServingRule>{ lowerPriorityRule, higherPriorityRule };
        System.assertEquals('test2', evaluator.evaluateVariation(featureConfig, FFTarget.builder().identifier('abc').build()));
    }
}