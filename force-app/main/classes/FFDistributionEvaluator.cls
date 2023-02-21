public abstract class FFDistributionEvaluator {

    public static string variationFromServe(FFModelsFeatures.Serve serve, FFTarget target) {
        if(serve != null){
            if(serve.distribution != null) {
                return FFDistributionEvaluator.variationFromDistribution(serve, target);
            }
            if(serve.variation != null) {
                return serve.variation;
            }
        }
        return null;
    }

   private static string variationFromDistribution(FFModelsFeatures.Serve serve, FFTarget target){
        if(serve.distribution != null && serve.distribution.variations != null){
            Integer totalPercentage = 0;
            for(FFModelsFeatures.WeightedVariation weightedVariation: serve.distribution.variations) {
                totalPercentage += weightedVariation.Weight;
                String bucketIdentifier = FFClauseEvaluator.getValue(serve.distribution.bucketBy, target);
                if (isEnabled(bucketIdentifier, serve.distribution.bucketBy, totalPercentage)){
                    return weightedVariation.Variation;
                }
            }
        }
        return null;
   }

   private static Decimal hexToDecimal(String input) {
        String alphabet = '0123456789abcdef';
        Decimal acc = 0;
        for(Integer index = 0; index < input.length(); index++) {
            acc = (acc * 16) + alphabet.indexOf(input.subString(index, index + 1));
        }
        return acc;
    }

   public static Boolean isEnabled(String targetValue, String bucketByValue, Integer percentage) {
        if(percentage == 0) return false;
        Blob targetBlob = Blob.valueOf(targetValue + ':' + bucketByValue);
        String hash = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', targetBlob)).substring(0, 15);
        Double full = (Double)hexToDecimal(hash) / Double.valueOf('1152921504606846975');
        Double hashNumber = (Double)((Decimal)(full)).setScale(8);
        Integer bucketID = (Integer)Math.floor(hashNumber * 100);
        return bucketID <= percentage;
   }
}

