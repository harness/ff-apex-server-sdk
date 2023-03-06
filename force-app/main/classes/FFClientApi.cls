public class FFClientApi implements FFAuthenticator {
    FFBaseCallout client;

    public FFClientApi(FFBaseCallout client) {
        this.client = client;
    }

    public FFBaseCallout getClient() {
        return this.client;
    }

    /**
     * Authenticate with the admin server.
     * Used to retrieve all target segments for certain account id.
     * @param ffAuthenticationRequest  (optional)
     * @return FFAuthenticationResponse
     * @throws FFBase.ApiException if fails to make API call
     */
    public FFModels.AuthenticationResponse authenticate(Map<String, Object> params) {
        List<FFBase.Param> query = new List<FFBase.Param>();
        List<FFBase.Param> form = new List<FFBase.Param>();

        return (FFModels.AuthenticationResponse) client.invoke(
            'POST', '/client/auth',
            (FFModels.AuthenticationRequest) params.get('ffAuthenticationRequest'),
            query, form,
            new Map<String, Object>(),
            new Map<String, Object>(),
            new List<String>{ 'application/json' },
            new List<String>{ 'application/json' },
            new List<String>(),
            FFModels.AuthenticationResponse.class
        );
    }

    /**
     * Get all feature flags activations
     * 
     * @param environmentUUID Unique identifier for the environment object in the API. (required)
     * @param cluster Unique identifier for the cluster for the account (optional)
     * @return List<FFModelsFeatures.FeatureConfig>
     * @throws FFBase.ApiException if fails to make API call
     */
    public List<FFModelsFeatures.FeatureConfig> getFeatureConfigs(Map<String, Object> params) {
        client.assertNotNull(params.get('environmentUUID'), 'environmentUUID');
        List<FFBase.Param> query = new List<FFBase.Param>();

        // cast query params to verify their expected type
        query.addAll(client.makeParam('cluster', (String) params.get('cluster')));

        List<FFBase.Param> form = new List<FFBase.Param>();

        return (List<FFModelsFeatures.FeatureConfig>) client.invoke(
            'GET', '/client/env/{environmentUUID}/feature-configs', '',
            query, form,
            new Map<String, Object>{
                'environmentUUID' => (String) params.get('environmentUUID')
            },
            new Map<String, Object>(),
            new List<String>{ 'application/json' },
            new List<String>(),
            new List<String> { 'BearerAuth' },
            List<FFModelsFeatures.FeatureConfig>.class
        );
    }

     /**
     * Used to retrieve all segments for certain account id.
     * 
     * @param environmentUUID Unique identifier for the environment object in the API. (required)
     * @param cluster Unique identifier for the cluster for the account (optional)
     * @return List<FFModelsFeatures.TargetSegment>
     * @throws FFBase.ApiException if fails to make API call
     */
    public List<FFModelsFeatures.TargetSegment> getTargetSegments(Map<String, Object> params) {
        client.assertNotNull(params.get('environmentUUID'), 'environmentUUID');
        List<FFBase.Param> query = new List<FFBase.Param>();

        // cast query params to verify their expected type
        query.addAll(client.makeParam('cluster', (String) params.get('cluster')));

        List<FFBase.Param> form = new List<FFBase.Param>();

        return (List<FFModelsFeatures.TargetSegment>) client.invoke(
            'GET', '/client/env/{environmentUUID}/target-segments', '',
            query, form,
            new Map<String, Object>{
                'environmentUUID' => (String) params.get('environmentUUID')
            },
            new Map<String, Object>(),
            new List<String>{ 'application/json' },
            new List<String>(),
            new List<String> { 'BearerAuth' },
            List<FFModelsFeatures.TargetSegment>.class
        );
    }

    /**
     * Stream endpoint.
     * 
     * @param apIKey  (required)
     * @param cluster Unique identifier for the cluster for the account (optional)
     * @throws FFBase.ApiException if fails to make API call
     */
    public void stream(Map<String, Object> params) {
        client.assertNotNull(params.get('apIKey'), 'apIKey');
        List<FFBase.Param> query = new List<FFBase.Param>();

        // cast query params to verify their expected type
        query.addAll(client.makeParam('cluster', (String) params.get('cluster')));

        List<FFBase.Param> form = new List<FFBase.Param>();

        client.invoke(
            'GET', '/stream', '',
            query, form,
            new Map<String, Object>(),
            new Map<String, Object>{
                'API-Key' => (String) params.get('apIKey')
            },
            new List<String>(),
            new List<String>(),
            new List<String> { 'BearerAuth' },
            null
        );
    }
}
