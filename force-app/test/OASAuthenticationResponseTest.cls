@isTest
private class OASAuthenticationResponseTest {
    @isTest
    private static void equalsSameInstance() {
        OASAuthenticationResponse authenticationResponse1 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse2 = authenticationResponse1;
        OASAuthenticationResponse authenticationResponse3 = new OASAuthenticationResponse();
        OASAuthenticationResponse authenticationResponse4 = authenticationResponse3;

        System.assert(authenticationResponse1.equals(authenticationResponse2));
        System.assert(authenticationResponse2.equals(authenticationResponse1));
        System.assert(authenticationResponse1.equals(authenticationResponse1));
        System.assert(authenticationResponse3.equals(authenticationResponse4));
        System.assert(authenticationResponse4.equals(authenticationResponse3));
        System.assert(authenticationResponse3.equals(authenticationResponse3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASAuthenticationResponse authenticationResponse1 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse2 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse3 = new OASAuthenticationResponse();
        OASAuthenticationResponse authenticationResponse4 = new OASAuthenticationResponse();

        System.assert(authenticationResponse1.equals(authenticationResponse2));
        System.assert(authenticationResponse2.equals(authenticationResponse1));
        System.assert(authenticationResponse3.equals(authenticationResponse4));
        System.assert(authenticationResponse4.equals(authenticationResponse3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASAuthenticationResponse authenticationResponse1 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse2 = new OASAuthenticationResponse();

        System.assertEquals(false, authenticationResponse1.equals('foo'));
        System.assertEquals(false, authenticationResponse2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASAuthenticationResponse authenticationResponse1 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse2 = new OASAuthenticationResponse();
        OASAuthenticationResponse authenticationResponse3;

        System.assertEquals(false, authenticationResponse1.equals(authenticationResponse3));
        System.assertEquals(false, authenticationResponse2.equals(authenticationResponse3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASAuthenticationResponse authenticationResponse1 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse2 = new OASAuthenticationResponse();

        System.assertEquals(authenticationResponse1.hashCode(), authenticationResponse1.hashCode());
        System.assertEquals(authenticationResponse2.hashCode(), authenticationResponse2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASAuthenticationResponse authenticationResponse1 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse2 = OASAuthenticationResponse.getExample();
        OASAuthenticationResponse authenticationResponse3 = new OASAuthenticationResponse();
        OASAuthenticationResponse authenticationResponse4 = new OASAuthenticationResponse();

        System.assert(authenticationResponse1.equals(authenticationResponse2));
        System.assert(authenticationResponse3.equals(authenticationResponse4));
        System.assertEquals(authenticationResponse1.hashCode(), authenticationResponse2.hashCode());
        System.assertEquals(authenticationResponse3.hashCode(), authenticationResponse4.hashCode());
    }
}
