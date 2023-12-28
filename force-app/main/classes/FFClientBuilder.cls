public class FFClientBuilder {

    private final String sdkKey;
    private final FFConfig config;
    private Integer pollingIntervalInSeconds = 0;

    @TestVisible
    private class AlwaysFalse implements Callable {

        public Object call(String action, Map<String, Object> args) {
            return false;
        }
    }

    public FFClientBuilder(String sdkKey, FFConfig config) {
        this.sdkKey = sdkKey;
        this.config = config;
    }

    public FFClientBuilder withPolling(Integer pollingIntervalInSeconds) {
       this.pollingIntervalInSeconds = pollingIntervalInSeconds;
       return this;
    }

    public FFClient build(){
        FFClient client = FFClient.create(this.sdkKey, this.config);

        // Fetch initial cache values 
        client.updateCache();

        Boolean isPollingEnabled = pollingIntervalInSeconds > 0;
        if (!isPollingEnabled) {
            return client;
        }

        new FFPoller(new FFClient.CacheUpdator(client))
        .staticDelay(this.pollingIntervalInSeconds)
        .untilTrue(new AlwaysFalse())
        .execute();
        return client;
    }
}
