public abstract class FFClauseEvaluator {

    public static Boolean evaluateClause(FFModelsFeatures.Clause clause, FFTarget target, FFSegmentEvaluator segmentEvaluator) {
        if(clause == null || String.isEmpty(clause.op) || clause.values == null || clause.values.size() == 0) {
            return false;
        }
        if(clause.op == 'segmentMatch') {
            return segmentEvaluator.targetIncludedInSegment(clause.values, target);
        }
        String attribute = FFClauseEvaluator.getValue(clause.attribute, target);
        if(attribute == null) return false;
        return FFClauseEvaluator.evaluateStringCondition(clause, attribute);
    }

    private static Boolean evaluateStringCondition(FFModelsFeatures.Clause clause, String attribute) {
        String firstValue = clause.values.get(0);
        switch on clause.op {
            when 'starts_with' {
                return attribute.startsWith(firstValue);
            }
            when 'ends_with' {
                return attribute.endsWith(firstValue);
            }
            when 'match' {
                return Pattern.matches(firstValue, attribute);
            }
            when 'contains' {
                return attribute.contains(firstValue);
            }
            when 'equal' {
                return attribute.toLowerCase().equals(firstValue.toLowerCase());
            }
            when 'attrStr' {
                return attribute.equals(firstValue);
            }
            when 'in' {
                return clause.values.contains(attribute);
            }
            when else {
                return false;
            }
        }
    }

    public static String getValue(String attribute, FFTarget target) {
        switch on attribute {
            when 'identifier' {
                return target.identifier;
            }
            when 'name' {
                return target.name;
            }
            when else {
                if(target.attributes != null && target.attributes.containsKey(attribute)) {
                    Object value = target.attributes.get(attribute);
                    if(value != null)
                        return String.valueOf(value);
                }
            }
        }
        return null;
    }
}