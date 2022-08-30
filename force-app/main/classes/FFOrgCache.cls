public class FFOrgCache implements FFCache {

    private String cacheNamespace = 'local';
    private String cachePartition = 'basic';

    public FFOrgCache(String cacheNamespace, String cachePartition) {
        if (cacheNamespace != null && cacheNamespace.equals('')) {
            throw new IllegalArgumentException('cacheNamespace cannot be empty');
        }

        if (cachePartition != null && cachePartition.equals('')) {
            throw new IllegalArgumentException('cachePartition cannot be empty');
        }

        this.cacheNamespace = cacheNamespace;
        this.cachePartition = cachePartition;
    }

    public void put(String key, Object value, Integer ttl) {
        Cache.Org.put(key, value, ttl);
    }

    public Object get(String key) {
        return Cache.Org.get(key);
    }

    public String getCacheNamespace() {
        return this.cacheNamespace;
    }

    public String getCachePartition() {
        return this.cachePartition;
    }
}
