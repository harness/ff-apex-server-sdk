@isTest
private class FFMetricsTest {
    @isTest
    private static void equalsSameInstance() {
        FFMetrics metrics1 = FFMetrics.getExample();
        FFMetrics metrics2 = metrics1;
        FFMetrics metrics3 = new FFMetrics();
        FFMetrics metrics4 = metrics3;

        System.assert(metrics1.equals(metrics2));
        System.assert(metrics2.equals(metrics1));
        System.assert(metrics1.equals(metrics1));
        System.assert(metrics3.equals(metrics4));
        System.assert(metrics4.equals(metrics3));
        System.assert(metrics3.equals(metrics3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFMetrics metrics1 = FFMetrics.getExample();
        FFMetrics metrics2 = FFMetrics.getExample();
        FFMetrics metrics3 = new FFMetrics();
        FFMetrics metrics4 = new FFMetrics();

        System.assert(metrics1.equals(metrics2));
        System.assert(metrics2.equals(metrics1));
        System.assert(metrics3.equals(metrics4));
        System.assert(metrics4.equals(metrics3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFMetrics metrics1 = FFMetrics.getExample();
        FFMetrics metrics2 = new FFMetrics();

        System.assertEquals(false, metrics1.equals('foo'));
        System.assertEquals(false, metrics2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFMetrics metrics1 = FFMetrics.getExample();
        FFMetrics metrics2 = new FFMetrics();
        FFMetrics metrics3;

        System.assertEquals(false, metrics1.equals(metrics3));
        System.assertEquals(false, metrics2.equals(metrics3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFMetrics metrics1 = FFMetrics.getExample();
        FFMetrics metrics2 = new FFMetrics();

        System.assertEquals(metrics1.hashCode(), metrics1.hashCode());
        System.assertEquals(metrics2.hashCode(), metrics2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFMetrics metrics1 = FFMetrics.getExample();
        FFMetrics metrics2 = FFMetrics.getExample();
        FFMetrics metrics3 = new FFMetrics();
        FFMetrics metrics4 = new FFMetrics();

        System.assert(metrics1.equals(metrics2));
        System.assert(metrics3.equals(metrics4));
        System.assertEquals(metrics1.hashCode(), metrics2.hashCode());
        System.assertEquals(metrics3.hashCode(), metrics4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        FFMetrics metrics = new FFMetrics();
        System.assertEquals(new List<FFTargetData>(), metrics.targetData);
        System.assertEquals(new List<FFMetricsData>(), metrics.metricsData);
    }
}
