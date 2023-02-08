public class FFFeatureConfig {

    public String project { get; set; }

    public String environment { get; set; }

    public String feature { get; set; }

    public String state { get; set; }

    public String kind { get; set; }

    public List<FFFeatureVariation> variations { get; set; }

    public FFFeatureServe defaultServe { get; set; }

    public String offVariation { get; set; }


    //OPTIONAL
    public List<FFFeatureServingRule> rules { get; set; }
    //OPTIONAL
    public List<FFFeaturePrerequisite> prerequisites { get; set; }
    //OPTIONAL
    public List<FFFeatureVariationMap> variationToTargetMap { get; set; }
    //OPTIONAL
    public Integer version { get; set; }

}

