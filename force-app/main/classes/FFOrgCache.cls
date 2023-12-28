public class FFOrgCache implements FFCache {

    private String cacheNamespace = 'local';
    private String cachePartition = 'basic';

    private enum EntryType { FEATURE, SEGMENT, AUTH, LAST_AUTH }

    /* Cache keys cannot have any non-alphanumeric characters */
    private String stripNonAlphanumeric(String str) {
        Pattern filter = Pattern.compile('[^a-zA-Z0-9]');
        return filter.matcher(str).replaceAll('');
    }

    private String makeKey(EntryType type, String key) {
        return cacheNamespace + '.' + cachePartition + '.' + type.name() + stripNonAlphanumeric(key);
    }

    public FFOrgCache(String cacheNamespace, String cachePartition) {
        if(cacheNamespace != null) {
            if (cacheNamespace.equals('')) {
                throw new IllegalArgumentException('cacheNamespace cannot be empty');
            } else {
                this.cacheNamespace = cacheNamespace;
            }
        }

        if (cachePartition != null){
            if(cachePartition.equals('')) {
                throw new IllegalArgumentException('cachePartition cannot be empty');
            } else {
                this.cachePartition = cachePartition;
            }
        }
    }

    public void putFeatures(List<FFModelsFeatures.FeatureConfig> features, Integer ttl) {
        for (FFModelsFeatures.FeatureConfig feature: features) {
            String key = makeKey(EntryType.FEATURE, feature.feature);
            System.debug('Caching feature config: ' + key);
            Cache.Org.put(key, feature, ttl);
        }
    }

    public void putSegments(List<FFModelsFeatures.TargetSegment> segments, Integer ttl) {
        for (FFModelsFeatures.TargetSegment segment: segments) {
            String key = makeKey(EntryType.SEGMENT, segment.identifier);
            System.debug('Caching segment config: ' + key);
            Cache.Org.put(key, segment, ttl);
        }
    }

    public void putAuth(String sdkKey, Map<String, String> authData, Integer ttl) {
        String key = makeKey(EntryType.AUTH, sdkKey);
        System.debug('Caching auth: ' + key);
        Cache.Org.put(key, authData, ttl);
    }

    public void putLastAuthTimeWithoutTTL(String sdkKey, String lastAuthTime) {
        String key = makeKey(EntryType.LAST_AUTH, sdkKey);
        System.debug('Caching last auth time: ' + key);
        Cache.Org.put(key, lastAuthTime);
    }

    public List<FFModelsFeatures.FeatureConfig> getFeatures() {
        List<FFModelsFeatures.FeatureConfig> features = new List<FFModelsFeatures.FeatureConfig>();
        for (String nextKey : Cache.Org.getKeys()) {
            if (nextKey.startsWith(EntryType.FEATURE.name())) {
                features.add((FFModelsFeatures.FeatureConfig)Cache.Org.get(nextKey));
            }
        }
        return features;
    }

    public List<FFModelsFeatures.TargetSegment> getSegments() {
        List<FFModelsFeatures.TargetSegment> segments = new List<FFModelsFeatures.TargetSegment>();
        for (String nextKey : Cache.Org.getKeys()) {
            if (nextKey.startsWith(EntryType.SEGMENT.name())) {
                segments.add((FFModelsFeatures.TargetSegment)Cache.Org.get(nextKey));
            }
        }
        return segments;
    }

    public Map<String, String> getKey(String sdkKey) {
        String key = makeKey(EntryType.AUTH, sdkKey);
        System.debug('Get auth: ' + key);
        return (Map<String, String>) Cache.Org.get(key);
    }

    public String getLastAuthKey(String sdkKey) {
        String key = makeKey(EntryType.LAST_AUTH, sdkKey);
        System.debug('Get last auth: ' + key);
        return (String) Cache.Org.get(key);
    }

    public String getCacheNamespace() {
        return this.cacheNamespace;
    }

}
