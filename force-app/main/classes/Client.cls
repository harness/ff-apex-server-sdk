public class Client {

    private Config config;
    private OASClient client;

    public Client(String sdkKey, Config config) {
        this.config = config;
        OASClient client = new OASClient(this.config);
        OASClientApi api = new OASClientApi(client);

        OASAuthenticationRequestTarget target = new OASAuthenticationRequestTarget();
        target.identifier = 'Harness';
        target.name = 'Harness';

        OASAuthenticationRequest req = new OASAuthenticationRequest();
        req.apiKey = sdkKey;
        req.target = target;


        Map<String, Object> params = new Map<String, Object>{
            'oaSAuthenticationRequest' => req
        };

        try {
            OASAuthenticationResponse result = api.authenticate(params);
            System.debug(result);
        } catch (OAS.ApiException e) {
            System.debug(e);
        }
    }
}
