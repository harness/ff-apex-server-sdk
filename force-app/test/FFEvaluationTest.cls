@isTest
private class FFEvaluationTest {
    @isTest
    private static void equalsSameInstance() {
        FFEvaluation evaluation1 = FFEvaluation.getExample();
        FFEvaluation evaluation2 = evaluation1;
        FFEvaluation evaluation3 = new FFEvaluation();
        FFEvaluation evaluation4 = evaluation3;

        System.assert(evaluation1.equals(evaluation2));
        System.assert(evaluation2.equals(evaluation1));
        System.assert(evaluation1.equals(evaluation1));
        System.assert(evaluation3.equals(evaluation4));
        System.assert(evaluation4.equals(evaluation3));
        System.assert(evaluation3.equals(evaluation3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFEvaluation evaluation1 = FFEvaluation.getExample();
        FFEvaluation evaluation2 = FFEvaluation.getExample();
        FFEvaluation evaluation3 = new FFEvaluation();
        FFEvaluation evaluation4 = new FFEvaluation();

        System.assert(evaluation1.equals(evaluation2));
        System.assert(evaluation2.equals(evaluation1));
        System.assert(evaluation3.equals(evaluation4));
        System.assert(evaluation4.equals(evaluation3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFEvaluation evaluation1 = FFEvaluation.getExample();
        FFEvaluation evaluation2 = new FFEvaluation();

        System.assertEquals(false, evaluation1.equals('foo'));
        System.assertEquals(false, evaluation2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFEvaluation evaluation1 = FFEvaluation.getExample();
        FFEvaluation evaluation2 = new FFEvaluation();
        FFEvaluation evaluation3;

        System.assertEquals(false, evaluation1.equals(evaluation3));
        System.assertEquals(false, evaluation2.equals(evaluation3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFEvaluation evaluation1 = FFEvaluation.getExample();
        FFEvaluation evaluation2 = new FFEvaluation();

        System.assertEquals(evaluation1.hashCode(), evaluation1.hashCode());
        System.assertEquals(evaluation2.hashCode(), evaluation2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFEvaluation evaluation1 = FFEvaluation.getExample();
        FFEvaluation evaluation2 = FFEvaluation.getExample();
        FFEvaluation evaluation3 = new FFEvaluation();
        FFEvaluation evaluation4 = new FFEvaluation();

        System.assert(evaluation1.equals(evaluation2));
        System.assert(evaluation3.equals(evaluation4));
        System.assertEquals(evaluation1.hashCode(), evaluation2.hashCode());
        System.assertEquals(evaluation3.hashCode(), evaluation4.hashCode());
    }
}
