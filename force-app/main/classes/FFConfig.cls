public class FFConfig {

    private static final String BASE_URL = 'https://config.ff.harness.io/api/1.0';
    private static final String EVENTS_URL = 'https://event.ff.harness.io/api/1.0';
    private static final Boolean METRICS_ENABLED = false;

    private String baseUrl = BASE_URL;
    private String eventsUrl = EVENTS_URL;
    private Boolean metricsEnabled = METRICS_ENABLED;

    private FFCache cache;

    private Integer evalExpireAfter = 60000;
    private Integer authExpireAfter = 60000 * 60 * 24;

    public FFConfig(String baseUrl, String eventsUrl, Boolean metricsEnabled, Integer evalExpireAfter, Integer authExpireAfter,
                    FFCache cache) {
        this.baseUrl = baseUrl;
        this.eventsUrl = eventsUrl;
        this.metricsEnabled = metricsEnabled;
        this.evalExpireAfter = evalExpireAfter;
        this.authExpireAfter = authExpireAfter;
        this.cache = cache;
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

    public Integer getEvalExpireAfter() {
        return this.evalExpireAfter;
    }

    public Integer getAuthExpireAfter() {
        return this.authExpireAfter;
    }

    public FFCache getCache() {
        return this.cache;
    }

    public static Builder builder() {
        return new Builder();
    }

    public class Builder {

        private String baseUrl = FFConfig.BASE_URL;
        private String eventsUrl = FFConfig.EVENTS_URL;
        private Boolean metricsEnabled = METRICS_ENABLED;

        private Integer evalExpireAfter = 300;
        private Integer authExpireAfter = 60 * 60 * 24;

        private FFCache cache;

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

        public Builder evalExpireAfter(Integer ms) {
            this.evalExpireAfter = ms;
            return this;
        }

        public Builder authExpireAfter(Integer ms) {
            this.authExpireAfter = ms;
            return this;
        }

        public Builder cache(FFCache cache) {
            this.cache = cache;
            return this;
        }

        public FFConfig build() {
            return new FFConfig(
                this.baseUrl,
                this.eventsUrl,
                this.metricsEnabled,
                this.evalExpireAfter,
                this.authExpireAfter,
                this.cache
            );
        }
    }
}
