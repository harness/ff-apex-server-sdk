public class FFClient {

    private final String sdkKey;
    private final FFConfig config;
    private final FFClientApi api;
    private final FFMetricsApi metricsApi;

    private String environmentUUID;
    private String cluster = '1';

    private static Integer maxRetry = 5;
    private final Long waitInterval = 2000;

    public virtual class AuthException extends Exception {}

    public FFClient(FFClientApi api, FFMetricsApi metricsApi, FFConfig config, String environmentUUID, String cluster) {
        this.sdkKey = sdkKey;
        this.config = config;
        this.api = api;
        this.metricsApi = metricsApi;
        this.environmentUUID = environmentUUID;
        this.cluster = cluster;
    }

    private Map<String, String> envAndClusterRequestParams() {
        return new Map<String, String> { 'environmentUUID' => this.environmentUUID, 'cluster' => this.cluster };
    }

    public static FFClient create(String sdkKey, FFConfig config) {
        FFBaseCallout apiClient = new FFBaseCallout(config.baseUrl, 'ff_client_apis');
        FFBaseCallout eventsClient = new FFBaseCallout(config.eventsUrl, 'ff_event_apis');
        FFClientApi api = new FFClientApi(apiClient);
        FFMetricsApi metricsApi = new FFMetricsApi(eventsClient);
        System.debug(config.eventsUrl);
        FFAuthService authService = new FFAuthServiceCached(sdkKey, config, api);
        FFModels.AuthInfo authResult = authService.authenticate();
        apiClient.setJWTToken(authResult.authToken);
        eventsClient.setJWTToken(authResult.authToken);
        return new FFClient(api, metricsApi, config, authResult.environmentUUID, authResult.cluster);
    }

    private String removeSpecChars(String s) {
        String text = s.substring(0);
        return text.replaceAll('[^a-zA-Z0-9\\s+]', '');
    }

    public void updateCache() {
        FFCache cache = this.config.cache;
        List<FFModelsFeatures.FeatureConfig> features = this.api.getFeatureConfigs(this.envAndClusterRequestParams());
        cache.put(FFCacheKeys.getFeatureConfigsKey(cache), features, this.config.featureConfigTimeToLive);
        List<FFModelsFeatures.TargetSegment> segments = this.api.getTargetSegments(this.envAndClusterRequestParams());
        cache.put(FFCacheKeys.getTargetSegmentsKey(cache), segments, this.config.featureConfigTimeToLive);
    }

    private List<FFModelsFeatures.FeatureConfig> getFeatureConfigs() {
        FFCache cache = this.config.cache;
        List<FFModelsFeatures.FeatureConfig> featureConfigs = (List<FFModelsFeatures.FeatureConfig>) cache.get(FFCacheKeys.getFeatureConfigsKey(cache));
        if(featureConfigs == null) {
            List<FFModelsFeatures.FeatureConfig> updated = this.api.getFeatureConfigs(this.envAndClusterRequestParams());
            cache.put(FFCacheKeys.getFeatureConfigsKey(cache), updated, this.config.featureConfigTimeToLive);
            return updated;
        }
        return featureConfigs;
    }

    private List<FFModelsFeatures.TargetSegment> getTargetSegments() {
        FFCache cache = this.config.cache;
        List<FFModelsFeatures.TargetSegment> targetSegments = (List<FFModelsFeatures.TargetSegment>) cache.get(FFCacheKeys.getTargetSegmentsKey(cache));
        if(targetSegments == null) {
            List<FFModelsFeatures.TargetSegment> updated = this.api.getTargetSegments(this.envAndClusterRequestParams());
            cache.put(FFCacheKeys.getTargetSegmentsKey(cache), updated, this.config.featureConfigTimeToLive);
            return updated;
        }
        return targetSegments;
    }

    private static FFModelsFeatures.FeatureConfig getFlag(List<FFModelsFeatures.FeatureConfig> featureConfigs, String key) {
        for(FFModelsFeatures.FeatureConfig featureConfig: featureConfigs) {
            if(featureConfig.feature == key) return featureConfig;
        }
        return null;
    }

    private FFModelsFeatures.Variation offVariation(FFModelsFeatures.FeatureConfig featureConfig) {
        for(FFModelsFeatures.Variation variation: featureConfig.variations){
            if(variation.identifier == featureConfig.offVariation) {
                return variation;
            }
        }
        return null;
    }

    private void pushMetrics(FFTarget target, FFModelsFeatures.FeatureConfig config, FFModelsFeatures.Variation variation) {
        if(this.config.metricsEnabled) {
            try{
                FFModelsEvents.Metrics metrics = new FFModelsEvents.Metrics();
                metrics.targetData = new List<FFModelsEvents.TargetData>();
                FFModelsEvents.TargetData targetData = new FFModelsEvents.TargetData();
                targetData.identifier = target.identifier;
                targetData.name = target.name;
                if(target.attributes != null){
                    for(String key: target.attributes.keySet()){
                        targetData.attributes.add(FFClient.keyValueFor(key, String.valueOf(target.attributes.get(key))));
                    }
                }
                metrics.targetData.add(targetData);
                FFModelsEvents.MetricsData metricsData = new FFModelsEvents.MetricsData();
                metricsData.timestamp = Datetime.now().getTime();
                metricsData.count = 1;
                metricsData.metricsType = FFModelsEvents.MetricsTypeEnum.FFMETRICS;
                metricsData.attributes.add(FFClient.keyValueFor('featureName', config.feature));
                metricsData.attributes.add(FFClient.keyValueFor('variationIdentifier', variation.identifier));
                metricsData.attributes.add(FFClient.keyValueFor('featureValue', variation.value));
                if(target.anonymous == true) {
                    metricsData.attributes.add(FFClient.keyValueFor('target', 'anonymous'));
                } else {
                    metricsData.attributes.add(FFClient.keyValueFor('target', target.identifier));
                }
                metricsData.attributes.add(FFClient.keyValueFor('SDK_TYPE', 'server'));
                metricsData.attributes.add(FFClient.keyValueFor('SDK_LANGUAGE', 'APEX'));
                metrics.metricsData = new List<FFModelsEvents.MetricsData>();
                metrics.metricsData.add(metricsData);

                Map<String, Object> params = new Map<String, Object> {
                    'ffMetrics' => metrics,
                    'environment' => this.environmentUUID,
                    'cluster' => this.cluster
                };
                System.debug('Publishing Metrics');
                this.metricsApi.postMetrics(params);
            } catch(Exception e) {
                System.debug('Could not send metrics, ignoring');
                System.debug(e);
                throw e;
            }
        }
    }

    private static FFModelsEvents.KeyValue keyValueFor(String key, String value){
        FFModelsEvents.KeyValue keyValue = new FFModelsEvents.KeyValue();
        keyValue.key = key;
        keyValue.value = value;
        return keyValue;
    }


    private FFModelsFeatures.Variation evaluateVariation(String key, FFTarget target, String kind) {
        List<FFModelsFeatures.FeatureConfig> featureConfigs = this.getFeatureConfigs();
        FFModelsFeatures.FeatureConfig featureConfig = FFClient.getFlag(featureConfigs, key);
        if(featureConfig == null || featureConfig.kind != kind){
            return null;
        }
        FFSegmentEvaluator segmentEvaluator = new FFTargetSegmentEvaluator(this.getTargetSegments());
        FFFeatureEvaluator evaluator = FFFeatureEvaluator.defaultEvaluators(segmentEvaluator);
        FFPrerequisites prerequisites = new FFPrerequisites(featureConfigs, evaluator);
        if(!prerequisites.passesPrerequisiteChecks(featureConfig, target)) {
            FFModelsFeatures.Variation offVariant = this.offVariation(featureConfig);
            if(offVariant != null){
                this.pushMetrics(target, featureConfig, offVariant);
            }
            return offVariant;
        }
        FFModelsFeatures.Variation variation = evaluator.evaluate(featureConfig, target);
        if(variation != null){
            this.pushMetrics(target, featureConfig, variation);
        }
        return variation;
    }

    public Boolean boolVariation(String key, FFTarget target, Boolean defaultValue) {
        FFModelsFeatures.Variation variation = evaluateVariation(key, target, 'boolean');
        if(variation == null) return defaultValue;
        try {
            return Boolean.valueOf(variation.value);
        } catch(Exception e) {
            System.debug(e);
        }
        return defaultValue;
    }

    public Double numberVariation(String key, FFTarget target, Double defaultValue) {
        FFModelsFeatures.Variation variation = evaluateVariation(key, target, 'int');
        if(variation == null) return defaultValue;
        try {
            return Double.valueOf(variation.value);
        } catch(Exception e) {
            System.debug(e);
        }
        return defaultValue;
    }

    public String stringVariation(String key, FFTarget target, String defaultValue) {
        FFModelsFeatures.Variation variation = evaluateVariation(key, target, 'string');
        if(variation == null) return defaultValue;
        try {
            return String.valueOf(variation.value);
        } catch(Exception e) {
            System.debug(e);
        }
        return defaultValue;
    }

    public Object jsonVariation(String key, FFTarget target, Object defaultValue, Type type) {
        FFModelsFeatures.Variation variation = evaluateVariation(key, target, 'json');
        if(variation == null) return defaultValue;
        try {
            JsonParser parser = Json.createParser(variation.value);
            parser.nextToken();
            return parser.readValueAs(type);
        } catch(Exception e) {
            System.debug(e);
        }
        return defaultValue;
    }

    public static FFClientBuilder builder(String sdkKey, FFConfig config){
        return new FFClientBuilder(sdkKey, config);
    }
}
