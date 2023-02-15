public abstract class FFModelsFeatures {

    public class FeatureConfig {
        public String project { get; set; }
        public String environment { get; set; }
        public String feature { get; set; }
        public String state { get; set; }
        public String kind { get; set; }
        public List<Variation> variations { get; set; }
        public Serve defaultServe { get; set; }
        public String offVariation { get; set; }
        //OPTIONAL
        public List<ServingRule> rules { get; set; }
        //OPTIONAL
        public List<Prerequisite> prerequisites { get; set; }
        //OPTIONAL
        public List<VariationMap> variationToTargetMap { get; set; }
        //OPTIONAL
        public Integer version { get; set; }
    }

    public class Distribution {
        public String bucketBy { get; set; }
        public List<WeightedVariation> variations { get; set; }
    }

    public class Prerequisite {
        public String feature { get; set; }
        public List<String> variations { get; set; }
    }
    
    public class Serve {
        //OPTIONAL
        public Distribution distribution { get; set; }
        //OPTIONAL
        public String variation { get; set; }
    }

    public class Clause {
        public String id { get; set; }
        public String attribute { get; set; }
        public String op { get; set; }
        public List<String> values { get; set; }
        public Boolean negate { get; set; }
    }

    public class ServingRule implements Comparable {
        public String ruleId { get; set; }
        public Integer priority { get; set; }    
        public List<Clause> clauses { get; set; }    
        public Serve serve { get; set; }    
        public Integer compareTo(Object compareTo) {
            if(this.priority != null && compareTo != null && ((ServingRule)compareTo).priority != null)
                return this.priority - ((ServingRule)compareTo).priority;
            return 0;
        }    
    }
    
    public class TargetMap {
        public String identifier { get; set; }
        public String name { get; set; }
    }

    public class Variation {
        public String identifier { get; set; }
        public String value { get; set; }
        //OPTIONAL
        public String name { get; set; }
        //OPTIONAL
        public String description { get; set; }
    }

    public class VariationMap {
        public String variation { get; set; }
        //OPTIONAL
        public List<TargetMap> targets { get; set; }
        //OPTIONAL
        public List<String> targetSegments { get; set; }
    }
        
    public class WeightedVariation {
        public String variation { get; set; }
        public Integer weight { get; set; }
    }

    public class Tag {
        public String name { get; set; }
        //OPTIONAL
        public String value { get; set; }
    }
        
    public class TargetSegment {
        public String name { get; set; }
        public String identifier { get; set; }
        //OPTIONAL
        public String environment { get; set; }
        //OPTIONAL
        public List<Tag> tags { get; set; }
        //OPTIONAL
        public List<FFTarget> included { get; set; }
        //OPTIONAL
        public List<FFTarget> excluded { get; set; }
        //OPTIONAL
        public List<Clause> rules { get; set; }
        //OPTIONAL
        public Integer createdAt { get; set; }
        //OPTIONAL
        public Integer modifiedAt { get; set; }
        //OPTIONAL
        public Integer version { get; set; }
    }

    public class Evaluation {
        public String flag { get; set; }
        public String value { get; set; }
        public String kind { get; set; }
        public String identifier { get; set; }
    }    
    
}