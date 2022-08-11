@isTest
private class OASMetricsDataTest {
    @isTest
    private static void equalsSameInstance() {
        OASMetricsData metricsData1 = OASMetricsData.getExample();
        OASMetricsData metricsData2 = metricsData1;
        OASMetricsData metricsData3 = new OASMetricsData();
        OASMetricsData metricsData4 = metricsData3;

        System.assert(metricsData1.equals(metricsData2));
        System.assert(metricsData2.equals(metricsData1));
        System.assert(metricsData1.equals(metricsData1));
        System.assert(metricsData3.equals(metricsData4));
        System.assert(metricsData4.equals(metricsData3));
        System.assert(metricsData3.equals(metricsData3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASMetricsData metricsData1 = OASMetricsData.getExample();
        OASMetricsData metricsData2 = OASMetricsData.getExample();
        OASMetricsData metricsData3 = new OASMetricsData();
        OASMetricsData metricsData4 = new OASMetricsData();

        System.assert(metricsData1.equals(metricsData2));
        System.assert(metricsData2.equals(metricsData1));
        System.assert(metricsData3.equals(metricsData4));
        System.assert(metricsData4.equals(metricsData3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASMetricsData metricsData1 = OASMetricsData.getExample();
        OASMetricsData metricsData2 = new OASMetricsData();

        System.assertEquals(false, metricsData1.equals('foo'));
        System.assertEquals(false, metricsData2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASMetricsData metricsData1 = OASMetricsData.getExample();
        OASMetricsData metricsData2 = new OASMetricsData();
        OASMetricsData metricsData3;

        System.assertEquals(false, metricsData1.equals(metricsData3));
        System.assertEquals(false, metricsData2.equals(metricsData3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASMetricsData metricsData1 = OASMetricsData.getExample();
        OASMetricsData metricsData2 = new OASMetricsData();

        System.assertEquals(metricsData1.hashCode(), metricsData1.hashCode());
        System.assertEquals(metricsData2.hashCode(), metricsData2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASMetricsData metricsData1 = OASMetricsData.getExample();
        OASMetricsData metricsData2 = OASMetricsData.getExample();
        OASMetricsData metricsData3 = new OASMetricsData();
        OASMetricsData metricsData4 = new OASMetricsData();

        System.assert(metricsData1.equals(metricsData2));
        System.assert(metricsData3.equals(metricsData4));
        System.assertEquals(metricsData1.hashCode(), metricsData2.hashCode());
        System.assertEquals(metricsData3.hashCode(), metricsData4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        OASMetricsData metricsData = new OASMetricsData();
        System.assertEquals(new List<OASKeyValue>(), metricsData.attributes);
        System.assertEquals(null, metricsData.timestamp);
        System.assertEquals(null, metricsData.count);
        System.assertEquals(null, metricsData.metricsType);
    }
}
