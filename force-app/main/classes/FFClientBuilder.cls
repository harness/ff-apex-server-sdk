public class FFClientBuilder {

    private final String sdkKey;
    private final FFConfig config;
    private Integer pollingIntervalInSeconds = 0;
    private Boolean waitForinitialized = false;


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

    public FFClientBuilder withWaitForInitialized(Boolean waitForInitialzed) {
        this.waitForinitialized = waitForInitialzed;
        return this;
     }

    public FFClient build(){
        FFClient client = FFClient.create(this.sdkKey, this.config);

        
        if (this.waitForinitialized) {
            // Fetch flags/segments before returning the client
            client.updateCache();
        }

        Boolean isPollingEnabled = pollingIntervalInSeconds > 0;
        if (!isPollingEnabled) {
            return client;
        }

        new FFPoller(new FFClient.CacheUpdator(client, waitForinitialized))
        .staticDelay(this.pollingIntervalInSeconds)
        .untilTrue(new AlwaysFalse())
        .execute();
        return client;
    }
}
