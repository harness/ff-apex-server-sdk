public interface FFCache {

    void putFeatures(List<FFModelsFeatures.FeatureConfig> features, Integer ttl);
    void putSegments(List<FFModelsFeatures.TargetSegment> segments, Integer ttl);
    void putAuth(String key, Map<String, String> authData, Integer ttl);
    void putLastAuthTimeWithoutTTL(String key, Map<String, String> lastAuthTime);

    List<FFModelsFeatures.FeatureConfig> getFeatures();
    List<FFModelsFeatures.TargetSegment> getSegments();
    Map<String, String> getAuth(String key);

    String getCacheNamespace();
}
