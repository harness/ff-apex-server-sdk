@isTest
private class OASEvaluationTest {
    @isTest
    private static void equalsSameInstance() {
        OASEvaluation evaluation1 = OASEvaluation.getExample();
        OASEvaluation evaluation2 = evaluation1;
        OASEvaluation evaluation3 = new OASEvaluation();
        OASEvaluation evaluation4 = evaluation3;

        System.assert(evaluation1.equals(evaluation2));
        System.assert(evaluation2.equals(evaluation1));
        System.assert(evaluation1.equals(evaluation1));
        System.assert(evaluation3.equals(evaluation4));
        System.assert(evaluation4.equals(evaluation3));
        System.assert(evaluation3.equals(evaluation3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASEvaluation evaluation1 = OASEvaluation.getExample();
        OASEvaluation evaluation2 = OASEvaluation.getExample();
        OASEvaluation evaluation3 = new OASEvaluation();
        OASEvaluation evaluation4 = new OASEvaluation();

        System.assert(evaluation1.equals(evaluation2));
        System.assert(evaluation2.equals(evaluation1));
        System.assert(evaluation3.equals(evaluation4));
        System.assert(evaluation4.equals(evaluation3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASEvaluation evaluation1 = OASEvaluation.getExample();
        OASEvaluation evaluation2 = new OASEvaluation();

        System.assertEquals(false, evaluation1.equals('foo'));
        System.assertEquals(false, evaluation2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASEvaluation evaluation1 = OASEvaluation.getExample();
        OASEvaluation evaluation2 = new OASEvaluation();
        OASEvaluation evaluation3;

        System.assertEquals(false, evaluation1.equals(evaluation3));
        System.assertEquals(false, evaluation2.equals(evaluation3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASEvaluation evaluation1 = OASEvaluation.getExample();
        OASEvaluation evaluation2 = new OASEvaluation();

        System.assertEquals(evaluation1.hashCode(), evaluation1.hashCode());
        System.assertEquals(evaluation2.hashCode(), evaluation2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASEvaluation evaluation1 = OASEvaluation.getExample();
        OASEvaluation evaluation2 = OASEvaluation.getExample();
        OASEvaluation evaluation3 = new OASEvaluation();
        OASEvaluation evaluation4 = new OASEvaluation();

        System.assert(evaluation1.equals(evaluation2));
        System.assert(evaluation3.equals(evaluation4));
        System.assertEquals(evaluation1.hashCode(), evaluation2.hashCode());
        System.assertEquals(evaluation3.hashCode(), evaluation4.hashCode());
    }
}
