public abstract class FFDistributionEvaluator {

   public static string variationFromDistribution(FFFeatureServe serve){
        if(serve.distribution != null && serve.distribution.variations != null){
            for(FFFeatureWeightedVariation weightedVariation: serve.distribution.variations) {
                if(FFDistributionEvaluator.isEnabled(weightedVariation.weight)){
                    return weightedVariation.variation;
                }
            }
        }
        return null;
   }

   private static Boolean isEnabled(Integer percentage) {
       return percentage > 0 && (Math.random() * 100) <= percentage;
   }
}

