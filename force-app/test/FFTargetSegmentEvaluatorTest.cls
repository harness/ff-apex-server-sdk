@isTest
private class FFTargetSegmentEvaluatorTest {
    @isTest
    private static void shouldBeFalseWhenSemgnetsNull() {
        FFTargetSegmentEvaluator evaluator = new FFTargetSegmentEvaluator(null);
        System.assertEquals(false, evaluator.targetIncludedInSegment(null, null));
    }

    @isTest
    private static void shouldBeFalseWhenSemgnetsEmpty() {
        FFTargetSegmentEvaluator evaluator = new FFTargetSegmentEvaluator(new List<FFModelsFeatures.TargetSegment>());
        System.assertEquals(false, evaluator.targetIncludedInSegment(null, null));
    }

    @isTest
    private static void shouldBeFalseWhenExcludedIsNull() {
        List<FFModelsFeatures.TargetSegment> segments = new List<FFModelsFeatures.TargetSegment>();
        FFModelsFeatures.TargetSegment segment = new FFModelsFeatures.TargetSegment();
        segment.identifier = 'test';
        segment.excluded = null;
        segments.add(segment);
        FFTargetSegmentEvaluator evaluator = new FFTargetSegmentEvaluator(segments);
        System.assertEquals(false, evaluator.targetIncludedInSegment(null, null));
    }

    @isTest
    private static void shouldBeFalseWhenExcluded() {
        List<FFModelsFeatures.TargetSegment> segments = new List<FFModelsFeatures.TargetSegment>();
        FFModelsFeatures.TargetSegment segment = new FFModelsFeatures.TargetSegment();
        segment.identifier = 'test';
        segment.excluded = new List<FFTarget>{ FFTarget.builder().identifier('t-one').build() };
        segments.add(segment);
        FFTargetSegmentEvaluator evaluator = new FFTargetSegmentEvaluator(segments);
        System.assertEquals(false, evaluator.targetIncludedInSegment(new List<String>{'test'}, FFTarget.builder().identifier('t-one').build()));
    }

    @isTest
    private static void shouldBeTrueWhenIncluded() {
        List<FFModelsFeatures.TargetSegment> segments = new List<FFModelsFeatures.TargetSegment>();
        FFModelsFeatures.TargetSegment segment = new FFModelsFeatures.TargetSegment();
        segment.identifier = 'test';
        segment.included = new List<FFTarget>{ FFTarget.builder().identifier('t-one').build() };
        segments.add(segment);
        FFTargetSegmentEvaluator evaluator = new FFTargetSegmentEvaluator(segments);
        System.assertEquals(true, evaluator.targetIncludedInSegment(new List<String>{'test'}, FFTarget.builder().identifier('t-one').build()));
    }

    @isTest
    private static void shouldBeTrueWhenAnyRuleSucceeds() {
        List<FFModelsFeatures.TargetSegment> segments = new List<FFModelsFeatures.TargetSegment>();
        FFModelsFeatures.TargetSegment segment = new FFModelsFeatures.TargetSegment();
        segment.identifier = 'test';
        segment.rules = new List<FFModelsFeatures.Clause>();
        FFModelsFeatures.Clause rule1 = new FFModelsFeatures.Clause();
        rule1.attribute = 'name';
        rule1.op = 'starts_with';
        rule1.values = new List<String>{ 'abc' };
        segment.rules.add(rule1);
        FFModelsFeatures.Clause rule2 = new FFModelsFeatures.Clause();
        rule2.attribute = 'name';
        rule2.op = 'ends_with';
        rule2.values = new List<String>{ 'def' };
        segment.rules.add(rule2);
        segments.add(segment);
        FFTargetSegmentEvaluator evaluator = new FFTargetSegmentEvaluator(segments);
        //sarts with abc
        System.assertEquals(true, evaluator.targetIncludedInSegment(new List<String>{'test'}, FFTarget.builder().identifier('t-one').name('abcxyz').build()));
        //ends with def
        System.assertEquals(true, evaluator.targetIncludedInSegment(new List<String>{'test'}, FFTarget.builder().identifier('t-one').name('xyzdef').build()));
        //none
        System.assertEquals(false, evaluator.targetIncludedInSegment(new List<String>{'test'}, FFTarget.builder().identifier('t-one').name('xyz').build()));
    }
}