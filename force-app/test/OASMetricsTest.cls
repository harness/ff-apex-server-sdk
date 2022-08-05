@isTest
private class OASMetricsTest {
    @isTest
    private static void equalsSameInstance() {
        OASMetrics metrics1 = OASMetrics.getExample();
        OASMetrics metrics2 = metrics1;
        OASMetrics metrics3 = new OASMetrics();
        OASMetrics metrics4 = metrics3;

        System.assert(metrics1.equals(metrics2));
        System.assert(metrics2.equals(metrics1));
        System.assert(metrics1.equals(metrics1));
        System.assert(metrics3.equals(metrics4));
        System.assert(metrics4.equals(metrics3));
        System.assert(metrics3.equals(metrics3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASMetrics metrics1 = OASMetrics.getExample();
        OASMetrics metrics2 = OASMetrics.getExample();
        OASMetrics metrics3 = new OASMetrics();
        OASMetrics metrics4 = new OASMetrics();

        System.assert(metrics1.equals(metrics2));
        System.assert(metrics2.equals(metrics1));
        System.assert(metrics3.equals(metrics4));
        System.assert(metrics4.equals(metrics3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASMetrics metrics1 = OASMetrics.getExample();
        OASMetrics metrics2 = new OASMetrics();

        System.assertEquals(false, metrics1.equals('foo'));
        System.assertEquals(false, metrics2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASMetrics metrics1 = OASMetrics.getExample();
        OASMetrics metrics2 = new OASMetrics();
        OASMetrics metrics3;

        System.assertEquals(false, metrics1.equals(metrics3));
        System.assertEquals(false, metrics2.equals(metrics3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASMetrics metrics1 = OASMetrics.getExample();
        OASMetrics metrics2 = new OASMetrics();

        System.assertEquals(metrics1.hashCode(), metrics1.hashCode());
        System.assertEquals(metrics2.hashCode(), metrics2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASMetrics metrics1 = OASMetrics.getExample();
        OASMetrics metrics2 = OASMetrics.getExample();
        OASMetrics metrics3 = new OASMetrics();
        OASMetrics metrics4 = new OASMetrics();

        System.assert(metrics1.equals(metrics2));
        System.assert(metrics3.equals(metrics4));
        System.assertEquals(metrics1.hashCode(), metrics2.hashCode());
        System.assertEquals(metrics3.hashCode(), metrics4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        OASMetrics metrics = new OASMetrics();
        System.assertEquals(new List<OASTargetData>(), metrics.targetData);
        System.assertEquals(new List<OASMetricsData>(), metrics.metricsData);
    }
}
