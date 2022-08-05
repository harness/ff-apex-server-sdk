@isTest
private class OASAuthenticationRequestTargetTest {
    @isTest
    private static void equalsSameInstance() {
        OASAuthenticationRequestTarget authenticationRequestTarget1 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget2 = authenticationRequestTarget1;
        OASAuthenticationRequestTarget authenticationRequestTarget3 = new OASAuthenticationRequestTarget();
        OASAuthenticationRequestTarget authenticationRequestTarget4 = authenticationRequestTarget3;

        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget2));
        System.assert(authenticationRequestTarget2.equals(authenticationRequestTarget1));
        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget1));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget4));
        System.assert(authenticationRequestTarget4.equals(authenticationRequestTarget3));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASAuthenticationRequestTarget authenticationRequestTarget1 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget2 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget3 = new OASAuthenticationRequestTarget();
        OASAuthenticationRequestTarget authenticationRequestTarget4 = new OASAuthenticationRequestTarget();

        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget2));
        System.assert(authenticationRequestTarget2.equals(authenticationRequestTarget1));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget4));
        System.assert(authenticationRequestTarget4.equals(authenticationRequestTarget3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASAuthenticationRequestTarget authenticationRequestTarget1 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget2 = new OASAuthenticationRequestTarget();

        System.assertEquals(false, authenticationRequestTarget1.equals('foo'));
        System.assertEquals(false, authenticationRequestTarget2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASAuthenticationRequestTarget authenticationRequestTarget1 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget2 = new OASAuthenticationRequestTarget();
        OASAuthenticationRequestTarget authenticationRequestTarget3;

        System.assertEquals(false, authenticationRequestTarget1.equals(authenticationRequestTarget3));
        System.assertEquals(false, authenticationRequestTarget2.equals(authenticationRequestTarget3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASAuthenticationRequestTarget authenticationRequestTarget1 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget2 = new OASAuthenticationRequestTarget();

        System.assertEquals(authenticationRequestTarget1.hashCode(), authenticationRequestTarget1.hashCode());
        System.assertEquals(authenticationRequestTarget2.hashCode(), authenticationRequestTarget2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASAuthenticationRequestTarget authenticationRequestTarget1 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget2 = OASAuthenticationRequestTarget.getExample();
        OASAuthenticationRequestTarget authenticationRequestTarget3 = new OASAuthenticationRequestTarget();
        OASAuthenticationRequestTarget authenticationRequestTarget4 = new OASAuthenticationRequestTarget();

        System.assert(authenticationRequestTarget1.equals(authenticationRequestTarget2));
        System.assert(authenticationRequestTarget3.equals(authenticationRequestTarget4));
        System.assertEquals(authenticationRequestTarget1.hashCode(), authenticationRequestTarget2.hashCode());
        System.assertEquals(authenticationRequestTarget3.hashCode(), authenticationRequestTarget4.hashCode());
    }
}
