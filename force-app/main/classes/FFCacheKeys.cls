public abstract class FFCacheKeys {

    public static String getCacheKey(String key) {
        return key.replaceAll('-', '');
    }
}

