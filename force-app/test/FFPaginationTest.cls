@isTest
private class FFPaginationTest {
    @isTest
    private static void equalsSameInstance() {
        FFPagination pagination1 = FFPagination.getExample();
        FFPagination pagination2 = pagination1;
        FFPagination pagination3 = new FFPagination();
        FFPagination pagination4 = pagination3;

        System.assert(pagination1.equals(pagination2));
        System.assert(pagination2.equals(pagination1));
        System.assert(pagination1.equals(pagination1));
        System.assert(pagination3.equals(pagination4));
        System.assert(pagination4.equals(pagination3));
        System.assert(pagination3.equals(pagination3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFPagination pagination1 = FFPagination.getExample();
        FFPagination pagination2 = FFPagination.getExample();
        FFPagination pagination3 = new FFPagination();
        FFPagination pagination4 = new FFPagination();

        System.assert(pagination1.equals(pagination2));
        System.assert(pagination2.equals(pagination1));
        System.assert(pagination3.equals(pagination4));
        System.assert(pagination4.equals(pagination3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFPagination pagination1 = FFPagination.getExample();
        FFPagination pagination2 = new FFPagination();

        System.assertEquals(false, pagination1.equals('foo'));
        System.assertEquals(false, pagination2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFPagination pagination1 = FFPagination.getExample();
        FFPagination pagination2 = new FFPagination();
        FFPagination pagination3;

        System.assertEquals(false, pagination1.equals(pagination3));
        System.assertEquals(false, pagination2.equals(pagination3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFPagination pagination1 = FFPagination.getExample();
        FFPagination pagination2 = new FFPagination();

        System.assertEquals(pagination1.hashCode(), pagination1.hashCode());
        System.assertEquals(pagination2.hashCode(), pagination2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFPagination pagination1 = FFPagination.getExample();
        FFPagination pagination2 = FFPagination.getExample();
        FFPagination pagination3 = new FFPagination();
        FFPagination pagination4 = new FFPagination();

        System.assert(pagination1.equals(pagination2));
        System.assert(pagination3.equals(pagination4));
        System.assertEquals(pagination1.hashCode(), pagination2.hashCode());
        System.assertEquals(pagination3.hashCode(), pagination4.hashCode());
    }
}
