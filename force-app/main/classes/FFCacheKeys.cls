public abstract class FFCacheKeys {
    
    public static String cachePrefix(FFCache cache) {
        return cache.getCacheNamespace() + '.' + cache.getCachePartition();
    }

    public static String getAuthCacheKey(FFCache cache, String sdkKey) {
        return FFCacheKeys.cachePrefix(cache) + '.auth' + sdkKey.replaceAll('-', '');
    }

    public static String getFeatureConfigsKey(FFCache cache) {
        return FFCacheKeys.cachePrefix(cache) + '.featureConfigs';
    }

    public static String getTargetSegmentsKey(FFCache cache) {
        return FFCacheKeys.cachePrefix(cache) + '.targetSegments';
    }
}

