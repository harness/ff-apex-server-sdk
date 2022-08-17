@isTest
private class FFAuthenticationRequestTargetTest {
    @isTest
    private static void equalsSameInstance() {
        FFAuthenticationRequestTarget authenticationRequestTarget1 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget2 = authenticationRequestTarget1;
        FFAuthenticationRequestTarget authenticationRequestTarget3 = new FFAuthenticationRequestTarget();
        FFAuthenticationRequestTarget authenticationRequestTarget4 = authenticationRequestTarget3;

        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget2));
        System.assert(authenticationRequestTarget2.equals(authenticationRequestTarget1));
        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget1));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget4));
        System.assert(authenticationRequestTarget4.equals(authenticationRequestTarget3));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFAuthenticationRequestTarget authenticationRequestTarget1 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget2 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget3 = new FFAuthenticationRequestTarget();
        FFAuthenticationRequestTarget authenticationRequestTarget4 = new FFAuthenticationRequestTarget();

        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget2));
        System.assert(authenticationRequestTarget2.equals(authenticationRequestTarget1));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget4));
        System.assert(authenticationRequestTarget4.equals(authenticationRequestTarget3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFAuthenticationRequestTarget authenticationRequestTarget1 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget2 = new FFAuthenticationRequestTarget();

        System.assertEquals(false, authenticationRequestTarget1.equals('foo'));
        System.assertEquals(false, authenticationRequestTarget2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFAuthenticationRequestTarget authenticationRequestTarget1 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget2 = new FFAuthenticationRequestTarget();
        FFAuthenticationRequestTarget authenticationRequestTarget3;

        System.assertEquals(false, authenticationRequestTarget1.equals(authenticationRequestTarget3));
        System.assertEquals(false, authenticationRequestTarget2.equals(authenticationRequestTarget3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFAuthenticationRequestTarget authenticationRequestTarget1 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget2 = new FFAuthenticationRequestTarget();

        System.assertEquals(authenticationRequestTarget1.hashCode(), authenticationRequestTarget1.hashCode());
        System.assertEquals(authenticationRequestTarget2.hashCode(), authenticationRequestTarget2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFAuthenticationRequestTarget authenticationRequestTarget1 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget2 = FFAuthenticationRequestTarget.getExample();
        FFAuthenticationRequestTarget authenticationRequestTarget3 = new FFAuthenticationRequestTarget();
        FFAuthenticationRequestTarget authenticationRequestTarget4 = new FFAuthenticationRequestTarget();

        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget2));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget4));
        System.assertEquals(authenticationRequestTarget1.hashCode(), authenticationRequestTarget2.hashCode());
        System.assertEquals(authenticationRequestTarget3.hashCode(), authenticationRequestTarget4.hashCode());
    }
}
