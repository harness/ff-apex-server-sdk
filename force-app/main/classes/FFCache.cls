public interface FFCache {

    void put(String key, Object value, Integer ttl);

    Object get(String key);

    String getCacheNamespace();

    String getCachePartition();
}
