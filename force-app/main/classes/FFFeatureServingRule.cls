public class FFFeatureServingRule {

    public String ruleId { get; set; }

    public Integer priority { get; set; }

    public List<FFClause> clauses { get; set; }

    public FFFeatureServe serve { get; set; }

    public Integer compareto(Object compareTo) {
        return this.priority - ((FFFeatureServingRule)compareTo).priority;
    }

}

