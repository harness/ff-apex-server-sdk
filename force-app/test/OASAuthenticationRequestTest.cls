@isTest
private class OASAuthenticationRequestTest {
    @isTest
    private static void equalsSameInstance() {
        OASAuthenticationRequest authenticationRequest1 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest2 = authenticationRequest1;
        OASAuthenticationRequest authenticationRequest3 = new OASAuthenticationRequest();
        OASAuthenticationRequest authenticationRequest4 = authenticationRequest3;

        System.assert(authenticationRequest1.equals(authenticationRequest2));
        System.assert(authenticationRequest2.equals(authenticationRequest1));
        System.assert(authenticationRequest1.equals(authenticationRequest1));
        System.assert(authenticationRequest3.equals(authenticationRequest4));
        System.assert(authenticationRequest4.equals(authenticationRequest3));
        System.assert(authenticationRequest3.equals(authenticationRequest3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASAuthenticationRequest authenticationRequest1 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest2 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest3 = new OASAuthenticationRequest();
        OASAuthenticationRequest authenticationRequest4 = new OASAuthenticationRequest();

        System.assert(authenticationRequest1.equals(authenticationRequest2));
        System.assert(authenticationRequest2.equals(authenticationRequest1));
        System.assert(authenticationRequest3.equals(authenticationRequest4));
        System.assert(authenticationRequest4.equals(authenticationRequest3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASAuthenticationRequest authenticationRequest1 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest2 = new OASAuthenticationRequest();

        System.assertEquals(false, authenticationRequest1.equals('foo'));
        System.assertEquals(false, authenticationRequest2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASAuthenticationRequest authenticationRequest1 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest2 = new OASAuthenticationRequest();
        OASAuthenticationRequest authenticationRequest3;

        System.assertEquals(false, authenticationRequest1.equals(authenticationRequest3));
        System.assertEquals(false, authenticationRequest2.equals(authenticationRequest3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASAuthenticationRequest authenticationRequest1 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest2 = new OASAuthenticationRequest();

        System.assertEquals(authenticationRequest1.hashCode(), authenticationRequest1.hashCode());
        System.assertEquals(authenticationRequest2.hashCode(), authenticationRequest2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASAuthenticationRequest authenticationRequest1 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest2 = OASAuthenticationRequest.getExample();
        OASAuthenticationRequest authenticationRequest3 = new OASAuthenticationRequest();
        OASAuthenticationRequest authenticationRequest4 = new OASAuthenticationRequest();

        System.assert(authenticationRequest1.equals(authenticationRequest2));
        System.assert(authenticationRequest3.equals(authenticationRequest4));
        System.assertEquals(authenticationRequest1.hashCode(), authenticationRequest2.hashCode());
        System.assertEquals(authenticationRequest3.hashCode(), authenticationRequest4.hashCode());
    }
}
