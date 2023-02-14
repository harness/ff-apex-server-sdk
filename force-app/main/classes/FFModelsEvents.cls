public abstract class FFModelsEvents {

    public class Metrics {
        public List<TargetData> targetData { get; set; }
        public List<MetricsData> metricsData { get; set; }
    
        public Metrics() {
            targetData = new List<TargetData>();
            metricsData = new List<MetricsData>();
        }
    }

    public class KeyValue {
        public String key { get; set; }
        public String value { get; set; }
    }


    public enum MetricsTypeEnum {
        FFMETRICS
    }

    public class MetricsData {
        public Long timestamp { get; set; }
        public Integer count { get; set; }
        public MetricsTypeEnum metricsType { get; set; }
        public List<KeyValue> attributes { get; set; }
    
        public MetricsData() {
            attributes = new List<KeyValue>();
        }
    }

    public class TargetData {
        public String identifier { get; set; }
        public String name { get; set; }
        public List<KeyValue> attributes { get; set; }
    
        public TargetData() {
            attributes = new List<KeyValue>();
        }
    }
    

}