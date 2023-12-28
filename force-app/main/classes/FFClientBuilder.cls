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
        Boolean isPollingEnabled = pollingIntervalInSeconds > 0;
        FFClient client = FFClient.create(this.sdkKey, this.config);
        // If polling isn't enabled, fetch flags/segments here as the poller is responsible for
        // updating the cache when it's enabled.
        if (!isPollingEnabled) {
            client.updateCache();
            return client;
        }

        new FFPoller(new FFClient.CacheUpdator(client))
        .staticDelay(this.pollingIntervalInSeconds)
        .untilTrue(new AlwaysFalse())
        .execute();
        return client;
    }
}
