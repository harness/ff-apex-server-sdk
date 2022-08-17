@isTest
private class FFMetricsDataTest {
    @isTest
    private static void equalsSameInstance() {
        FFMetricsData metricsData1 = FFMetricsData.getExample();
        FFMetricsData metricsData2 = metricsData1;
        FFMetricsData metricsData3 = new FFMetricsData();
        FFMetricsData metricsData4 = metricsData3;

        System.assert(metricsData1.equals(metricsData2));
        System.assert(metricsData2.equals(metricsData1));
        System.assert(metricsData1.equals(metricsData1));
        System.assert(metricsData3.equals(metricsData4));
        System.assert(metricsData4.equals(metricsData3));
        System.assert(metricsData3.equals(metricsData3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFMetricsData metricsData1 = FFMetricsData.getExample();
        FFMetricsData metricsData2 = FFMetricsData.getExample();
        FFMetricsData metricsData3 = new FFMetricsData();
        FFMetricsData metricsData4 = new FFMetricsData();

        System.assert(metricsData1.equals(metricsData2));
        System.assert(metricsData2.equals(metricsData1));
        System.assert(metricsData3.equals(metricsData4));
        System.assert(metricsData4.equals(metricsData3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFMetricsData metricsData1 = FFMetricsData.getExample();
        FFMetricsData metricsData2 = new FFMetricsData();

        System.assertEquals(false, metricsData1.equals('foo'));
        System.assertEquals(false, metricsData2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFMetricsData metricsData1 = FFMetricsData.getExample();
        FFMetricsData metricsData2 = new FFMetricsData();
        FFMetricsData metricsData3;

        System.assertEquals(false, metricsData1.equals(metricsData3));
        System.assertEquals(false, metricsData2.equals(metricsData3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFMetricsData metricsData1 = FFMetricsData.getExample();
        FFMetricsData metricsData2 = new FFMetricsData();

        System.assertEquals(metricsData1.hashCode(), metricsData1.hashCode());
        System.assertEquals(metricsData2.hashCode(), metricsData2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFMetricsData metricsData1 = FFMetricsData.getExample();
        FFMetricsData metricsData2 = FFMetricsData.getExample();
        FFMetricsData metricsData3 = new FFMetricsData();
        FFMetricsData metricsData4 = new FFMetricsData();

        System.assert(metricsData1.equals(metricsData2));
        System.assert(metricsData3.equals(metricsData4));
        System.assertEquals(metricsData1.hashCode(), metricsData2.hashCode());
        System.assertEquals(metricsData3.hashCode(), metricsData4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        FFMetricsData metricsData = new FFMetricsData();
        System.assertEquals(new List<FFKeyValue>(), metricsData.attributes);
        System.assertEquals(null, metricsData.timestamp);
        System.assertEquals(null, metricsData.count);
        System.assertEquals(null, metricsData.metricsType);
    }
}
