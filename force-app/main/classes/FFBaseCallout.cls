public class FFBaseCallout extends FFBase.ApiClient {
    public FFBaseCallout(FFConfig config) {
        basePath = config.getBaseUrl();
        calloutName = 'Harness_feature_flag_service_client_apis';
        authentications.put('ApiKeyAuth', new FFBase.ApiKeyHeaderAuth('api-key'));
    }
}
