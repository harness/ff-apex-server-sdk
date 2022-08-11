@isTest
private class OASTargetDataTest {
    @isTest
    private static void equalsSameInstance() {
        OASTargetData targetData1 = OASTargetData.getExample();
        OASTargetData targetData2 = targetData1;
        OASTargetData targetData3 = new OASTargetData();
        OASTargetData targetData4 = targetData3;

        System.assert(targetData1.equals(targetData2));
        System.assert(targetData2.equals(targetData1));
        System.assert(targetData1.equals(targetData1));
        System.assert(targetData3.equals(targetData4));
        System.assert(targetData4.equals(targetData3));
        System.assert(targetData3.equals(targetData3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASTargetData targetData1 = OASTargetData.getExample();
        OASTargetData targetData2 = OASTargetData.getExample();
        OASTargetData targetData3 = new OASTargetData();
        OASTargetData targetData4 = new OASTargetData();

        System.assert(targetData1.equals(targetData2));
        System.assert(targetData2.equals(targetData1));
        System.assert(targetData3.equals(targetData4));
        System.assert(targetData4.equals(targetData3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASTargetData targetData1 = OASTargetData.getExample();
        OASTargetData targetData2 = new OASTargetData();

        System.assertEquals(false, targetData1.equals('foo'));
        System.assertEquals(false, targetData2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASTargetData targetData1 = OASTargetData.getExample();
        OASTargetData targetData2 = new OASTargetData();
        OASTargetData targetData3;

        System.assertEquals(false, targetData1.equals(targetData3));
        System.assertEquals(false, targetData2.equals(targetData3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASTargetData targetData1 = OASTargetData.getExample();
        OASTargetData targetData2 = new OASTargetData();

        System.assertEquals(targetData1.hashCode(), targetData1.hashCode());
        System.assertEquals(targetData2.hashCode(), targetData2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASTargetData targetData1 = OASTargetData.getExample();
        OASTargetData targetData2 = OASTargetData.getExample();
        OASTargetData targetData3 = new OASTargetData();
        OASTargetData targetData4 = new OASTargetData();

        System.assert(targetData1.equals(targetData2));
        System.assert(targetData3.equals(targetData4));
        System.assertEquals(targetData1.hashCode(), targetData2.hashCode());
        System.assertEquals(targetData3.hashCode(), targetData4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        OASTargetData targetData = new OASTargetData();
        System.assertEquals(new List<OASKeyValue>(), targetData.attributes);
        System.assertEquals(null, targetData.identifier);
        System.assertEquals(null, targetData.name);
    }
}
