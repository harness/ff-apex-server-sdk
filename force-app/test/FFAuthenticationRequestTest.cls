@isTest
private class FFAuthenticationRequestTest {
    @isTest
    private static void equalsSameInstance() {
        FFAuthenticationRequest authenticationRequest1 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest2 = authenticationRequest1;
        FFAuthenticationRequest authenticationRequest3 = new FFAuthenticationRequest();
        FFAuthenticationRequest authenticationRequest4 = authenticationRequest3;

        System.assert(authenticationRequest1.equals(authenticationRequest2));
        System.assert(authenticationRequest2.equals(authenticationRequest1));
        System.assert(authenticationRequest1.equals(authenticationRequest1));
        System.assert(authenticationRequest3.equals(authenticationRequest4));
        System.assert(authenticationRequest4.equals(authenticationRequest3));
        System.assert(authenticationRequest3.equals(authenticationRequest3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFAuthenticationRequest authenticationRequest1 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest2 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest3 = new FFAuthenticationRequest();
        FFAuthenticationRequest authenticationRequest4 = new FFAuthenticationRequest();

        System.assert(authenticationRequest1.equals(authenticationRequest2));
        System.assert(authenticationRequest2.equals(authenticationRequest1));
        System.assert(authenticationRequest3.equals(authenticationRequest4));
        System.assert(authenticationRequest4.equals(authenticationRequest3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFAuthenticationRequest authenticationRequest1 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest2 = new FFAuthenticationRequest();

        System.assertEquals(false, authenticationRequest1.equals('foo'));
        System.assertEquals(false, authenticationRequest2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFAuthenticationRequest authenticationRequest1 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest2 = new FFAuthenticationRequest();
        FFAuthenticationRequest authenticationRequest3;

        System.assertEquals(false, authenticationRequest1.equals(authenticationRequest3));
        System.assertEquals(false, authenticationRequest2.equals(authenticationRequest3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFAuthenticationRequest authenticationRequest1 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest2 = new FFAuthenticationRequest();

        System.assertEquals(authenticationRequest1.hashCode(), authenticationRequest1.hashCode());
        System.assertEquals(authenticationRequest2.hashCode(), authenticationRequest2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFAuthenticationRequest authenticationRequest1 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest2 = FFAuthenticationRequest.getExample();
        FFAuthenticationRequest authenticationRequest3 = new FFAuthenticationRequest();
        FFAuthenticationRequest authenticationRequest4 = new FFAuthenticationRequest();

        System.assert(authenticationRequest1.equals(authenticationRequest2));
        System.assert(authenticationRequest3.equals(authenticationRequest4));
        System.assertEquals(authenticationRequest1.hashCode(), authenticationRequest2.hashCode());
        System.assertEquals(authenticationRequest3.hashCode(), authenticationRequest4.hashCode());
    }
}
