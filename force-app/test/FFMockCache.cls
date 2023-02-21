public class FFMockCache implements FFCache {
    public Map<String, Object> cache {get;set;}
    public FFMockCache() {
        this.cache = new Map<String, Object>();
    }
    public void put(String key, Object value, Integer ttl) { this.cache.put(key, value); }
    public Object get(String key) { return this.cache.get(key);}
    public String getCacheNamespace() { return 'TEST'; }
    public String getCachePartition() { return 'TEST'; }
}