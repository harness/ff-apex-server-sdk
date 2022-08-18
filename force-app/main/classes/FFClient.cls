public class FFClient {

    private FFConfig config;
    private FFBaseCallout client;

    public FFClient(String sdkKey, FFConfig config) {
        this.config = config;
        FFBaseCallout client = new FFBaseCallout(this.config);
        FFClientApi api = new FFClientApi(client);

        FFAuthenticationRequestTarget target = new FFAuthenticationRequestTarget();
        target.identifier = 'Harness';
        target.name = 'Harness';

        FFAuthenticationRequest req = new FFAuthenticationRequest();
        req.apiKey = sdkKey;
        req.target = target;


        Map<String, Object> params = new Map<String, Object>{
            'ffAuthenticationRequest' => req
        };

        try {
            FFAuthenticationResponse result = api.authenticate(params);
            System.debug(result);
        } catch (FFBase.ApiException e) {
            System.debug(e);
        }
    }
}
