@isTest
private class OASTargetTest {
    @isTest
    private static void equalsSameInstance() {
        OASTarget target1 = OASTarget.getExample();
        OASTarget target2 = target1;
        OASTarget target3 = new OASTarget();
        OASTarget target4 = target3;

        System.assert(target1.equals(target2));
        System.assert(target2.equals(target1));
        System.assert(target1.equals(target1));
        System.assert(target3.equals(target4));
        System.assert(target4.equals(target3));
        System.assert(target3.equals(target3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        OASTarget target1 = OASTarget.getExample();
        OASTarget target2 = OASTarget.getExample();
        OASTarget target3 = new OASTarget();
        OASTarget target4 = new OASTarget();

        System.assert(target1.equals(target2));
        System.assert(target2.equals(target1));
        System.assert(target3.equals(target4));
        System.assert(target4.equals(target3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        OASTarget target1 = OASTarget.getExample();
        OASTarget target2 = new OASTarget();

        System.assertEquals(false, target1.equals('foo'));
        System.assertEquals(false, target2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        OASTarget target1 = OASTarget.getExample();
        OASTarget target2 = new OASTarget();
        OASTarget target3;

        System.assertEquals(false, target1.equals(target3));
        System.assertEquals(false, target2.equals(target3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        OASTarget target1 = OASTarget.getExample();
        OASTarget target2 = new OASTarget();

        System.assertEquals(target1.hashCode(), target1.hashCode());
        System.assertEquals(target2.hashCode(), target2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        OASTarget target1 = OASTarget.getExample();
        OASTarget target2 = OASTarget.getExample();
        OASTarget target3 = new OASTarget();
        OASTarget target4 = new OASTarget();

        System.assert(target1.equals(target2));
        System.assert(target3.equals(target4));
        System.assertEquals(target1.hashCode(), target2.hashCode());
        System.assertEquals(target3.hashCode(), target4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        OASTarget target = new OASTarget();
        System.assertEquals(null, target.identifier);
        System.assertEquals(null, target.name);
        System.assertEquals(null, target.attributes);
    }
}
