public class FFConfig {

    private static final String BASE_URL = 'https://config.ff.harness.io/api/1.0';
    private static final String EVENTS_URL = 'https://event.ff.harness.io/api/1.0';
    private static final Boolean METRICS_ENABLED = false;

    private String baseUrl = BASE_URL;
    private String eventsUrl = EVENTS_URL;
    private Boolean metricsEnabled = METRICS_ENABLED;

    public FFConfig(String baseUrl, String eventsUrl, Boolean metricsEnabled) {
        this.baseUrl = baseUrl;
        this.eventsUrl = eventsUrl;
        this.metricsEnabled = metricsEnabled;
    }

    public String getBaseUrl() {
        return this.baseUrl;
    }

    public String getEventsUrl() {
        return this.eventsUrl;
    }

    public Boolean getMetricsEnabled() {
        return this.metricsEnabled;
    }

    public static Builder builder() {
        return new Builder();
    }

    public class Builder {

        private String baseUrl = FFConfig.BASE_URL;
        private String eventsUrl = FFConfig.EVENTS_URL;
        private Boolean metricsEnabled = METRICS_ENABLED;

        public Builder baseUrl(String url) {
            this.baseUrl = url;
            return this;
        }

        public Builder eventsUrl(String url) {
            this.eventsUrl = url;
            return this;
        }

        public Builder metricsEnabled(Boolean value) {
            this.metricsEnabled = value;
            return this;
        }

        public FFConfig build() {
            return new FFConfig(
                this.baseUrl,
                this.eventsUrl,
                this.metricsEnabled
            );
        }
    }
}
