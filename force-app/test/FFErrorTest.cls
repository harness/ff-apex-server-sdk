@isTest
private class FFErrorTest {
    @isTest
    private static void equalsSameInstance() {
        FFError error1 = FFError.getExample();
        FFError error2 = error1;
        FFError error3 = new FFError();
        FFError error4 = error3;

        System.assert(error1.equals(error2));
        System.assert(error2.equals(error1));
        System.assert(error1.equals(error1));
        System.assert(error3.equals(error4));
        System.assert(error4.equals(error3));
        System.assert(error3.equals(error3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFError error1 = FFError.getExample();
        FFError error2 = FFError.getExample();
        FFError error3 = new FFError();
        FFError error4 = new FFError();

        System.assert(error1.equals(error2));
        System.assert(error2.equals(error1));
        System.assert(error3.equals(error4));
        System.assert(error4.equals(error3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFError error1 = FFError.getExample();
        FFError error2 = new FFError();

        System.assertEquals(false, error1.equals('foo'));
        System.assertEquals(false, error2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFError error1 = FFError.getExample();
        FFError error2 = new FFError();
        FFError error3;

        System.assertEquals(false, error1.equals(error3));
        System.assertEquals(false, error2.equals(error3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFError error1 = FFError.getExample();
        FFError error2 = new FFError();

        System.assertEquals(error1.hashCode(), error1.hashCode());
        System.assertEquals(error2.hashCode(), error2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFError error1 = FFError.getExample();
        FFError error2 = FFError.getExample();
        FFError error3 = new FFError();
        FFError error4 = new FFError();

        System.assert(error1.equals(error2));
        System.assert(error3.equals(error4));
        System.assertEquals(error1.hashCode(), error2.hashCode());
        System.assertEquals(error3.hashCode(), error4.hashCode());
    }
}
