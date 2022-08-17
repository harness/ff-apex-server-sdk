@isTest
private class FFKeyValueTest {
    @isTest
    private static void equalsSameInstance() {
        FFKeyValue keyValue1 = FFKeyValue.getExample();
        FFKeyValue keyValue2 = keyValue1;
        FFKeyValue keyValue3 = new FFKeyValue();
        FFKeyValue keyValue4 = keyValue3;

        System.assert(keyValue1.equals(keyValue2));
        System.assert(keyValue2.equals(keyValue1));
        System.assert(keyValue1.equals(keyValue1));
        System.assert(keyValue3.equals(keyValue4));
        System.assert(keyValue4.equals(keyValue3));
        System.assert(keyValue3.equals(keyValue3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFKeyValue keyValue1 = FFKeyValue.getExample();
        FFKeyValue keyValue2 = FFKeyValue.getExample();
        FFKeyValue keyValue3 = new FFKeyValue();
        FFKeyValue keyValue4 = new FFKeyValue();

        System.assert(keyValue1.equals(keyValue2));
        System.assert(keyValue2.equals(keyValue1));
        System.assert(keyValue3.equals(keyValue4));
        System.assert(keyValue4.equals(keyValue3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFKeyValue keyValue1 = FFKeyValue.getExample();
        FFKeyValue keyValue2 = new FFKeyValue();

        System.assertEquals(false, keyValue1.equals('foo'));
        System.assertEquals(false, keyValue2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFKeyValue keyValue1 = FFKeyValue.getExample();
        FFKeyValue keyValue2 = new FFKeyValue();
        FFKeyValue keyValue3;

        System.assertEquals(false, keyValue1.equals(keyValue3));
        System.assertEquals(false, keyValue2.equals(keyValue3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFKeyValue keyValue1 = FFKeyValue.getExample();
        FFKeyValue keyValue2 = new FFKeyValue();

        System.assertEquals(keyValue1.hashCode(), keyValue1.hashCode());
        System.assertEquals(keyValue2.hashCode(), keyValue2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFKeyValue keyValue1 = FFKeyValue.getExample();
        FFKeyValue keyValue2 = FFKeyValue.getExample();
        FFKeyValue keyValue3 = new FFKeyValue();
        FFKeyValue keyValue4 = new FFKeyValue();

        System.assert(keyValue1.equals(keyValue2));
        System.assert(keyValue3.equals(keyValue4));
        System.assertEquals(keyValue1.hashCode(), keyValue2.hashCode());
        System.assertEquals(keyValue3.hashCode(), keyValue4.hashCode());
    }
}
