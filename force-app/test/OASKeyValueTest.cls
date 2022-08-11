@isTest
private class OASKeyValueTest {
    @isTest
    private static void equalsSameInstance() {
        OASKeyValue keyValue1 = OASKeyValue.getExample();
        OASKeyValue keyValue2 = keyValue1;
        OASKeyValue keyValue3 = new OASKeyValue();
        OASKeyValue keyValue4 = keyValue3;

        System.assert(keyValue1.equals(keyValue2));
        System.assert(keyValue2.equals(keyValue1));
        System.assert(keyValue1.equals(keyValue1));
        System.assert(keyValue3.equals(keyValue4));
        System.assert(keyValue4.equals(keyValue3));
        System.assert(keyValue3.equals(keyValue3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASKeyValue keyValue1 = OASKeyValue.getExample();
        OASKeyValue keyValue2 = OASKeyValue.getExample();
        OASKeyValue keyValue3 = new OASKeyValue();
        OASKeyValue keyValue4 = new OASKeyValue();

        System.assert(keyValue1.equals(keyValue2));
        System.assert(keyValue2.equals(keyValue1));
        System.assert(keyValue3.equals(keyValue4));
        System.assert(keyValue4.equals(keyValue3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASKeyValue keyValue1 = OASKeyValue.getExample();
        OASKeyValue keyValue2 = new OASKeyValue();

        System.assertEquals(false, keyValue1.equals('foo'));
        System.assertEquals(false, keyValue2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASKeyValue keyValue1 = OASKeyValue.getExample();
        OASKeyValue keyValue2 = new OASKeyValue();
        OASKeyValue keyValue3;

        System.assertEquals(false, keyValue1.equals(keyValue3));
        System.assertEquals(false, keyValue2.equals(keyValue3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASKeyValue keyValue1 = OASKeyValue.getExample();
        OASKeyValue keyValue2 = new OASKeyValue();

        System.assertEquals(keyValue1.hashCode(), keyValue1.hashCode());
        System.assertEquals(keyValue2.hashCode(), keyValue2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASKeyValue keyValue1 = OASKeyValue.getExample();
        OASKeyValue keyValue2 = OASKeyValue.getExample();
        OASKeyValue keyValue3 = new OASKeyValue();
        OASKeyValue keyValue4 = new OASKeyValue();

        System.assert(keyValue1.equals(keyValue2));
        System.assert(keyValue3.equals(keyValue4));
        System.assertEquals(keyValue1.hashCode(), keyValue2.hashCode());
        System.assertEquals(keyValue3.hashCode(), keyValue4.hashCode());
    }
}
