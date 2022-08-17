@isTest
private class FFTargetDataTest {
    @isTest
    private static void equalsSameInstance() {
        FFTargetData targetData1 = FFTargetData.getExample();
        FFTargetData targetData2 = targetData1;
        FFTargetData targetData3 = new FFTargetData();
        FFTargetData targetData4 = targetData3;

        System.assert(targetData1.equals(targetData2));
        System.assert(targetData2.equals(targetData1));
        System.assert(targetData1.equals(targetData1));
        System.assert(targetData3.equals(targetData4));
        System.assert(targetData4.equals(targetData3));
        System.assert(targetData3.equals(targetData3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFTargetData targetData1 = FFTargetData.getExample();
        FFTargetData targetData2 = FFTargetData.getExample();
        FFTargetData targetData3 = new FFTargetData();
        FFTargetData targetData4 = new FFTargetData();

        System.assert(targetData1.equals(targetData2));
        System.assert(targetData2.equals(targetData1));
        System.assert(targetData3.equals(targetData4));
        System.assert(targetData4.equals(targetData3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFTargetData targetData1 = FFTargetData.getExample();
        FFTargetData targetData2 = new FFTargetData();

        System.assertEquals(false, targetData1.equals('foo'));
        System.assertEquals(false, targetData2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFTargetData targetData1 = FFTargetData.getExample();
        FFTargetData targetData2 = new FFTargetData();
        FFTargetData targetData3;

        System.assertEquals(false, targetData1.equals(targetData3));
        System.assertEquals(false, targetData2.equals(targetData3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFTargetData targetData1 = FFTargetData.getExample();
        FFTargetData targetData2 = new FFTargetData();

        System.assertEquals(targetData1.hashCode(), targetData1.hashCode());
        System.assertEquals(targetData2.hashCode(), targetData2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFTargetData targetData1 = FFTargetData.getExample();
        FFTargetData targetData2 = FFTargetData.getExample();
        FFTargetData targetData3 = new FFTargetData();
        FFTargetData targetData4 = new FFTargetData();

        System.assert(targetData1.equals(targetData2));
        System.assert(targetData3.equals(targetData4));
        System.assertEquals(targetData1.hashCode(), targetData2.hashCode());
        System.assertEquals(targetData3.hashCode(), targetData4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        FFTargetData targetData = new FFTargetData();
        System.assertEquals(new List<FFKeyValue>(), targetData.attributes);
        System.assertEquals(null, targetData.identifier);
        System.assertEquals(null, targetData.name);
    }
}
