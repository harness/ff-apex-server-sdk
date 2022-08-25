public class FFConfig {

    private static final String BASE_URL = 'https://config.ff.harness.io/api/1.0';
    private static final String EVENTS_URL = 'https://event.ff.harness.io/api/1.0';
    private static final Boolean METRICS_ENABLED = false;

    private String baseUrl = BASE_URL;
    private String eventsUrl = EVENTS_URL;
    private Boolean metricsEnabled = METRICS_ENABLED;

    private Integer evalExpireAfter = 60000;
    private Integer authExpireAfter = 60000 * 60 * 24;

    private String cacheNamespace;
    private String cachePartition;

    public FFConfig(String baseUrl, String eventsUrl, Boolean metricsEnabled, Integer evalExpireAfter, Integer authExpireAfter,
                    String cacheNamespace, String cachePartition) {
        if (cacheNamespace.equals('')) {
            throw new IllegalArgumentException('cacheNamespace cannot be empty');
        }
        if (cachePartition.equals('')) {
            throw new IllegalArgumentException('cachePartition cannot be empty');
        }
        this.baseUrl = baseUrl;
        this.eventsUrl = eventsUrl;
        this.metricsEnabled = metricsEnabled;
        this.evalExpireAfter = evalExpireAfter;
        this.authExpireAfter = authExpireAfter;
        this.cacheNamespace = cacheNamespace;
        this.cachePartition = cachePartition;
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

    public String getCacheNamespace() {
        return this.cacheNamespace;
    }

    public String getCachePartition() {
        return this.cachePartition;
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

        private String cacheNamespace;
        private String cachePartition;

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

        public Builder cacheNamespace(String namespace) {
            this.cacheNamespace = namespace;
            return this;
        }

        public Builder cachePartition(String partition) {
            this.cachePartition = partition;
            return this;
        }

        public FFConfig build() {
            return new FFConfig(
                this.baseUrl,
                this.eventsUrl,
                this.metricsEnabled,
                this.evalExpireAfter,
                this.authExpireAfter,
                this.cacheNamespace,
                this.cachePartition
            );
        }
    }
}
