public class OASClient extends OAS.ApiClient {
    public OASClient(Config config) {
        basePath = config.getBaseUrl();
        calloutName = 'Harness_feature_flag_service_client_apis';
        authentications.put('ApiKeyAuth', new OAS.ApiKeyHeaderAuth('api-key'));
    }
}
