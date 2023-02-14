public class FFTargetSegmentEvaluator implements FFSegmentEvaluator {

    private final List<FFModelsFeatures.TargetSegment> currentSegments;
    public FFTargetSegmentEvaluator(List<FFModelsFeatures.TargetSegment> currentSegments) {
        this.currentSegments = currentSegments;
    }

    public Boolean targetIncludedInSegment(List<string> segments, FFTarget target) {
        if(segments != null) {
            for(String segmentIdentifier: segments) {
                FFModelsFeatures.TargetSegment segment = this.findSegment(segmentIdentifier);
                if(segment != null) {
                    if(this.targetExcluded(segment, target)){
                        return false;
                    }
                    if(this.targetIncluded(segment, target)){
                        return true;
                    }
                    if(segment.rules != null) {
                        return this.anyRuleSucceeds(segment.rules, target);
                    }
                }
            }
        }
        return false;
    }

    private Boolean targetIncluded(FFModelsFeatures.TargetSegment segment, FFTarget target) {
        if(segment.included != null) {
            for(FFTarget included: segment.included) {
                if(included.identifier == target.identifier) {
                    System.debug('Target ' + target.name + ' included in segment ' + included.name + ' via include list');
                    return true;
                }
            }
        }
        return false;
    }

    private Boolean targetExcluded(FFModelsFeatures.TargetSegment segment, FFTarget target) {
        if(segment.excluded != null) {
            for(FFTarget exclude: segment.excluded) {
                if(exclude.identifier == target.identifier) {
                    System.debug('Target ' + target.name + ' excluded from segment ' + exclude.name + ' via exclude list');
                    return true;
                }
            }
        }
        return false;
    }

    private FFModelsFeatures.TargetSegment findSegment(String identifier) {
        for(FFModelsFeatures.TargetSegment segment: this.currentSegments) {
            if(segment.identifier == identifier){
                return segment;
            }
        }
        return null;
    }



    private Boolean anyRuleSucceeds(List<FFModelsFeatures.Clause> rules, FFTarget target) {
        for(FFModelsFeatures.Clause clause: rules) {
            if(FFClauseEvaluator.evaluateClause(clause, target, this)) {
                return true;
            }
        }
        return false;
    }
}