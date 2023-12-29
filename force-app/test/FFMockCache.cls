public class FFMockCache implements FFCache {
    public Map<String, Object> cache {get;set;}
    public FFMockCache() {
        this.cache = new Map<String, Object>();
    }

    public void putFeatures(List<FFModelsFeatures.FeatureConfig> features, Integer ttl) {
        this.cache.put('features', features);
    }

    public void putSegments(List<FFModelsFeatures.TargetSegment> segments, Integer ttl) {
        this.cache.put('segments', segments);
    }

    public void putAuth(String key, Map<String, String> authData, Integer ttl) {
        this.cache.put('auth'+key, authData);
    }

    public void deleteAuth(String key) {
        this.cache.remove('auth'+key);
    } 


    public void putLastAuthTimeWithoutTTL(String key, Long lastAuthTime) {
        this.cache.put('lastAuth'+key, lastAuthTime);
    }

    public List<FFModelsFeatures.FeatureConfig> getFeatures() {
        return (List<FFModelsFeatures.FeatureConfig>) this.cache.get('features');
    }

    public List<FFModelsFeatures.TargetSegment> getSegments() {
        return (List<FFModelsFeatures.TargetSegment>) this.cache.get('segments');
    }

    public Map<String, String> getKey(String key) {
        return (Map<String, String>) this.cache.get(key);
    }

    public Long getLastAuthKey(String key) {
        return (Long) this.cache.get(key);
    }

    public String getCacheNamespace() { return 'TEST'; }
}