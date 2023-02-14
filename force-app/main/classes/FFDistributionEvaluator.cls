public abstract class FFDistributionEvaluator {

    class Weights {
        private final List<Integer> weights {get; private set;}
        private final Integer total { get; private set;}
        public Weights(List<Integer> weights, Integer total){
            this.weights = weights;
            this.total = total;
        }

        public Integer pickIndexFor(Integer location) {
            if(this.weights.size() == 1) return 0;
            Integer position = 0;
            Integer index = 0;
            for(Integer weight: this.weights) {
                if(location < position + weight) {
                    return index;
                }
                index++;
                position += weight;
            }
            return this.weights.size() - 1;
        }
    }

   public static string variationFromDistribution(FFModelsFeatures.Serve serve){
        if(serve.distribution != null && serve.distribution.variations != null){
            Weights weights = FFDistributionEvaluator.weights(serve.distribution.variations);
            Integer selectedLocation = FFDistributionEvaluator.selectLocation(weights.total);
            Integer index = weights.pickIndexFor(selectedLocation);
            return serve.distribution.variations[index].variation;
        }
        return null;
   }

   private static Weights weights(List<FFModelsFeatures.WeightedVariation> variations) {
        List<Integer> weights = new List<Integer>();
        Integer total = 0;
        for(FFModelsFeatures.WeightedVariation weightedVariation: variations) {
            weights.add(weightedVariation.weight);
            total += weightedVariation.weight;
        }
        return new Weights(weights, total);
   }

   private static Integer selectLocation(Integer total) {
       return (Integer)Math.floor(Math.random() * total);
   }
}

