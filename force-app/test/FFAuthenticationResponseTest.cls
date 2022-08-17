@isTest
private class FFAuthenticationResponseTest {
    @isTest
    private static void equalsSameInstance() {
        FFAuthenticationResponse authenticationResponse1 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse2 = authenticationResponse1;
        FFAuthenticationResponse authenticationResponse3 = new FFAuthenticationResponse();
        FFAuthenticationResponse authenticationResponse4 = authenticationResponse3;

        System.assert(authenticationResponse1.equals(authenticationResponse2));
        System.assert(authenticationResponse2.equals(authenticationResponse1));
        System.assert(authenticationResponse1.equals(authenticationResponse1));
        System.assert(authenticationResponse3.equals(authenticationResponse4));
        System.assert(authenticationResponse4.equals(authenticationResponse3));
        System.assert(authenticationResponse3.equals(authenticationResponse3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFAuthenticationResponse authenticationResponse1 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse2 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse3 = new FFAuthenticationResponse();
        FFAuthenticationResponse authenticationResponse4 = new FFAuthenticationResponse();

        System.assert(authenticationResponse1.equals(authenticationResponse2));
        System.assert(authenticationResponse2.equals(authenticationResponse1));
        System.assert(authenticationResponse3.equals(authenticationResponse4));
        System.assert(authenticationResponse4.equals(authenticationResponse3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFAuthenticationResponse authenticationResponse1 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse2 = new FFAuthenticationResponse();

        System.assertEquals(false, authenticationResponse1.equals('foo'));
        System.assertEquals(false, authenticationResponse2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFAuthenticationResponse authenticationResponse1 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse2 = new FFAuthenticationResponse();
        FFAuthenticationResponse authenticationResponse3;

        System.assertEquals(false, authenticationResponse1.equals(authenticationResponse3));
        System.assertEquals(false, authenticationResponse2.equals(authenticationResponse3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFAuthenticationResponse authenticationResponse1 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse2 = new FFAuthenticationResponse();

        System.assertEquals(authenticationResponse1.hashCode(), authenticationResponse1.hashCode());
        System.assertEquals(authenticationResponse2.hashCode(), authenticationResponse2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFAuthenticationResponse authenticationResponse1 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse2 = FFAuthenticationResponse.getExample();
        FFAuthenticationResponse authenticationResponse3 = new FFAuthenticationResponse();
        FFAuthenticationResponse authenticationResponse4 = new FFAuthenticationResponse();

        System.assert(authenticationResponse1.equals(authenticationResponse2));
        System.assert(authenticationResponse3.equals(authenticationResponse4));
        System.assertEquals(authenticationResponse1.hashCode(), authenticationResponse2.hashCode());
        System.assertEquals(authenticationResponse3.hashCode(), authenticationResponse4.hashCode());
    }
}
