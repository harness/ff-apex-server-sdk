public class FFBaseCallout extends FFBase.ApiClient {

    private String token;

    public FFBaseCallout(FFConfig config) {
        basePath = config.getBaseUrl();
        calloutName = 'ff_client_apis';
        authentications.put('ApiKeyAuth', new FFBase.ApiKeyHeaderAuth('api-key'));
    }

    public void setJWTToken(String token) {
        this.token = token;
    }

    public override void applyAuthentication(List<String> names, Map<String, Object> headers,
                                             List<Param> query) {
        if (names.contains('BearerAuth')) {
            headers.put('Authorization', 'Bearer ' + this.token);
        }
    }
}
