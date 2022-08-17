@isTest
private class FFTargetTest {
    @isTest
    private static void equalsSameInstance() {
        FFTarget target1 = FFTarget.getExample();
        FFTarget target2 = target1;
        FFTarget target3 = new FFTarget();
        FFTarget target4 = target3;

        System.assert(target1.equals(target2));
        System.assert(target2.equals(target1));
        System.assert(target1.equals(target1));
        System.assert(target3.equals(target4));
        System.assert(target4.equals(target3));
        System.assert(target3.equals(target3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        FFTarget target1 = FFTarget.getExample();
        FFTarget target2 = FFTarget.getExample();
        FFTarget target3 = new FFTarget();
        FFTarget target4 = new FFTarget();

        System.assert(target1.equals(target2));
        System.assert(target2.equals(target1));
        System.assert(target3.equals(target4));
        System.assert(target4.equals(target3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        FFTarget target1 = FFTarget.getExample();
        FFTarget target2 = new FFTarget();

        System.assertEquals(false, target1.equals('foo'));
        System.assertEquals(false, target2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        FFTarget target1 = FFTarget.getExample();
        FFTarget target2 = new FFTarget();
        FFTarget target3;

        System.assertEquals(false, target1.equals(target3));
        System.assertEquals(false, target2.equals(target3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        FFTarget target1 = FFTarget.getExample();
        FFTarget target2 = new FFTarget();

        System.assertEquals(target1.hashCode(), target1.hashCode());
        System.assertEquals(target2.hashCode(), target2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        FFTarget target1 = FFTarget.getExample();
        FFTarget target2 = FFTarget.getExample();
        FFTarget target3 = new FFTarget();
        FFTarget target4 = new FFTarget();

        System.assert(target1.equals(target2));
        System.assert(target3.equals(target4));
        System.assertEquals(target1.hashCode(), target2.hashCode());
        System.assertEquals(target3.hashCode(), target4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        FFTarget target = new FFTarget();
        System.assertEquals(null, target.identifier);
        System.assertEquals(null, target.name);
        System.assertEquals(null, target.attributes);
    }
}
