public interface FFCache {

    void putFeatures(List<FFModelsFeatures.FeatureConfig> features, Integer ttl);
    void putSegments(List<FFModelsFeatures.TargetSegment> segments, Integer ttl);
    void putAuth(String key, Map<String, String> authData, Integer ttl);
    void putLastAuthTimeWithoutTTL(String key, Long lastAuthTime);

    List<FFModelsFeatures.FeatureConfig> getFeatures();
    List<FFModelsFeatures.TargetSegment> getSegments();
    Map<String, String> getKey(String key);
    Long getLastAuthKey(String key);

    String getCacheNamespace();
}
