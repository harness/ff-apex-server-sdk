@isTest
private class FFOrgCacheTest {

    @isTest
    private static void shouldSetDefaults() {
        FFOrgCache orgCache = new FFOrgCache(null);
        System.assertEquals('local', orgCache.getCacheNamespace());
    }

    @isTest
    private static void shouldFailIfNamespaceIsEmpty() {
        try {
            FFOrgCache orgCache = new FFOrgCache('');
            System.assert(false, 'Should not get here');
        } catch(Exception e){
            System.assertEquals('cacheNamespace cannot be empty', e.getMessage());
        }
    }
}