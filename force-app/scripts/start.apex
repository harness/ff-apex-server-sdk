FFOrgCache cache = new FFOrgCache('local', 'TEST');
FFConfig config = FFConfig.builder().cache(cache).metricsEnabled().build();
FFClient client = FFClient.builder('e61ddf41-3309-4507-94f1-d09a0bd8a063', config).build();
FFTarget target = FFTarget.builder().identifier('Chris').name('Chris').build();
Boolean variation = client.boolVariation('x_test_1', target, false);
System.debug('Got Variation ' + variation);
