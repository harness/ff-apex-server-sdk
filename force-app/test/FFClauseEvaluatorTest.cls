@isTest
public class FFClauseEvaluatorTest {

    private static FFClause clause(String attribute, String op, String value) {
       FFClause clause = new FFClause();
       clause.op = op;
       clause.values = new List<String> { value };
       clause.attribute = attribute;
       return clause;
    }

    public class MockStaticSegmentEvaluator implements FFSegmentEvaluator {
        private Boolean staticReturnValue { get; set; }
        public MockStaticSegmentEvaluator(Boolean staticReturnValue) {
            this.staticReturnValue = staticReturnValue;
        }
        public Boolean targetIncludedInSegment(List<string> segments, FFTarget target) {
            return this.staticReturnValue;
        }
    }

    @isTest
    public static void shouldBeFalseWhenClauseNull() {
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(null, null, null));
    }

    @isTest
    public static void shouldBeFalseWhenOperationEmptyOrNull() {
       FFClause emptyOp = new FFClause();
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(emptyOp, null, null));
       emptyOp.op = '';
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(emptyOp, null, null));
    }

    @isTest
    public static void shouldBeFalseWhenValuesEmptyOrNull() {
       FFClause emptyValues = new FFClause();
       emptyValues.op = 'starts_with';
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(emptyValues, null, null));
       emptyValues.values = new List<String>();
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(emptyValues, null, null));
    }

    @isTest
    public static void shouldSegmentResultWhenOpIsSegmentMatch() {
       FFClause segmentMatch = new FFClause();
       segmentMatch.op = 'segmentMatch';
       segmentMatch.values = new List<String> { 'test1' };
       MockStaticSegmentEvaluator trueSegmentEvaluator = new MockStaticSegmentEvaluator(true);
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(segmentMatch, null, trueSegmentEvaluator));
       MockStaticSegmentEvaluator falseSegmentEvaluator = new MockStaticSegmentEvaluator(false);
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(segmentMatch, null, falseSegmentEvaluator));
    }

    @isTest
    public static void shouldBeFalseWhenTargetHasNoAttributes() {
       FFClause startsWith = FFClauseEvaluatorTest.clause('test', 'starts_with', '_test');
       FFTarget target = new FFTarget();
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(startsWith, target, null));
    }

    @isTest
    public static void shouldMatchAgainstTargetIdentifier() {
       FFClause startsWith = FFClauseEvaluatorTest.clause('identifier', 'starts_with', '_test');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'identifier' => 'not matched'
       };
       target.identifier = '_test123';
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(startsWith, target, null));
    }

    @isTest
    public static void shouldMatchAgainstTargetName() {
       FFClause startsWith = FFClauseEvaluatorTest.clause('name', 'starts_with', '_test');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'name' => 'not matched'
       };
       target.name = '_test123';
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(startsWith, target, null));
    }

    @isTest
    public static void shouldMatchAgainstNonStringAttribute() {
       FFClause startsWith = FFClauseEvaluatorTest.clause('att', 'starts_with', '123');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'att' => 1234
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(startsWith, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenAttributeIsNull() {
       FFClause startsWith = FFClauseEvaluatorTest.clause('att', 'starts_with', '123');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'att' => null
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(startsWith, target, null));
    }
    
    @isTest
    public static void shouldBeFalseWhenTargetAttDoesNotExist() {
       FFClause startsWith = FFClauseEvaluatorTest.clause('test', 'starts_with', '_test');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'not_test' => '_test'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(startsWith, target, null));
    }

    @isTest
    public static void shouldBeTrueWhenStartsWithValue() {
       FFClause startsWith = FFClauseEvaluatorTest.clause('test', 'starts_with', '_test');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '_testxyz'
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(startsWith, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenDoesNotStartWithValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'starts_with', '_test');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => 'not_test'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeTrueWhenEndsWithValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'ends_with', '_test');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => 'xyz_test'
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenDoesntEndWithValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'ends_with', '_test');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => 'xyz_testxyz'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeTrueWhenPatternMatchesValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'match', '^[a-z.]+@[a-z]+\\.[a-z]{2,}$');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => 'some.one@harness.io'
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenDoesntPatternMatchesValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'match', '^[a-z.]+@[a-z]+\\.[a-z]{2,}$');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '2302899023klsdjflkdsj'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeTrueWhenContainsValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'contains', 'xyz');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '123xyz456'
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenDoesntContainValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'contains', 'xyz');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '123xy456'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeTrueWhenEqualToValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'equal', 'xXyYzZ');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => 'XxyYZz' // Differing case to clause
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenNotEqualToValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'equal', 'xXyYzZ');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '123456'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeTrueWhenExactlyEqualToValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'attrStr', 'xXyYzZ');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => 'xXyYzZ' // Same case to clause
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenNotExactlyEqualToValue() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'attrStr', 'xXyYzZ');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => 'XxyYZz'  // Differing case to clause
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }


    @isTest
    public static void shouldBeTrueWhenInValues() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'in', 'xXyYzZ');
       clause.values.add('123456');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '123456'
       };
       System.assertEquals(true, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenNotInValues() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'in', 'xXyYzZ');
       clause.values.add('2392382039');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '123456'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

    @isTest
    public static void shouldBeFalseWhenInvalidOperation() {
       FFClause clause = FFClauseEvaluatorTest.clause('test', 'notAnOperation', 'xXyYzZ');
       FFTarget target = new FFTarget();
       target.attributes = new Map<String, Object> {
           'test' => '123456'
       };
       System.assertEquals(false, FFClauseEvaluator.evaluateClause(clause, target, null));
    }

}