public abstract class FFCacheKeys {

    public static String getAuthCacheKey(String sdkKey) {
        return sdkKey.replaceAll('-', '');
    }
}

