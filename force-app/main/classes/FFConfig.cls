public class FFConfig {

    public FFConfig(
        String baseUrl,
        String eventsUrl,
        Boolean metricsEnabled,
        Integer evalExpireAfter,
        Integer authExpireAfter,
        Integer featureConfigTimeToLive,
        Integer authRetries,
        FFCache cache
    ) {
        this.baseUrl = baseUrl;
        this.eventsUrl = eventsUrl;
        this.metricsEnabled = metricsEnabled;
        this.evalExpireAfter = evalExpireAfter;
        this.authExpireAfter = authExpireAfter;
        this.featureConfigTimeToLive = featureConfigTimeToLive;
        this.cache = cache;
        this.authRetries = authRetries;
    }

    public Integer authRetries { get; private set; }
    public String baseUrl { get; private set; }
    public String eventsUrl { get; private set; }
    public Boolean metricsEnabled { get; private set; }
    public Integer evalExpireAfter { get; private set; }
    public Integer authExpireAfter { get; private set; }
    public Integer featureConfigTimeToLive { get; private set; }
    public FFCache cache { get; private set; }

    public static Builder builder() {
        return new Builder();
    }

    public class Builder {

        private String baseUrl = 'https://config.ff.harness.io/api/1.0';
        private String eventsUrl = 'https://events.ff.harness.io/api/1.0';
        private Boolean metricsEnabled = false;

        private Integer evalExpireAfter = 300;
        private Integer featureConfigTimeToLive = 3600;
        private Integer authExpireAfter = 60 * 60 * 24;
        private Integer authRetries = 10;

        private FFCache cache;

        public Builder baseUrl(String url) {
            this.baseUrl = url;
            return this;
        }

        public Builder authRetries(Integer authRetries) {
            this.authRetries = authRetries;
            return this;
        }

        public Builder eventsUrl(String url) {
            this.eventsUrl = url;
            return this;
        }

        public Builder metricsEnabled() {
            this.metricsEnabled = true;
            return this;
        }

        public Builder featureConfigTimeToLive(Integer seconds) {
            this.featureConfigTimeToLive = seconds;
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
                this.featureConfigTimeToLive,
                this.authRetries,
                this.cache
            );
        }
    }
}
