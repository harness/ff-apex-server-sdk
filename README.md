APEX SDK For Harness Feature Flags
========================

[![SFDX Test Run on Push](https://github.com/harness/ff-apex-server-sdk/actions/workflows/ci.yaml/badge.svg)](https://github.com/harness/ff-apex-server-sdk/actions/workflows/ci.yaml)

## Table of Contents
**[Intro](#Intro)**<br>
**[Requirements](#Requirements)**<br>
**[Quickstart](#Quickstart)**<br>
**[Further Reading](docs/further_reading.md)**<br>
**[Build Instructions](docs/build.md)**<br>


## Intro
Use this README to get started with our Feature Flags (FF) SDK for APEX. This guide outlines the basics of getting started with the SDK and provides a full code sample for you to try out.
This sample doesn’t include configuration options, for in depth steps and configuring the SDK, for example, using our Relay Proxy, see the  [APEX SDK Reference](https://docs.harness.io/article/aoe0y33mut-apex-sdk-reference).

For a sample FF APEX SDK project, see our [test APEX project](https://github.com/harness/ff-apex-server-sample).

![FeatureFlags](./ff-gui.png)

## Requirements
[SalesForce SFDX cli](https://developer.salesforce.com/tools/sfdxcli)

## Quickstart
To follow along with our test code sample, make sure you’ve:

- [Created a Feature Flag on the Harness Platform](https://ngdocs.harness.io/article/1j7pdkqh7j-create-a-feature-flag) called harnessappdemodarkmode
- [Created a server SDK key and made a copy of it](https://ngdocs.harness.io/article/1j7pdkqh7j-create-a-feature-flag#step_3_create_an_sdk_key)


### Install the SDK
Install the APEX SDK using
```bash
sfdx force:source:deploy --targetusername='YOUR TARGET ORG' --sourcepath='force-app'
```

### Code Sample
The following is a complete code example that you can use to test the `harnessappdemodarkmode` Flag you created on the Harness Platform. When you run the code it will:
- Connect to the FF service.
- Report the value of the Flag.
- Close the SDK.

```apex
// Set flagKey to the feature flag key you want to evaluate.
String flag = 'harnessappdemodarkmode';


// set cache Namespace and Partition
FFOrgCache cache = new FFOrgCache('local', 'basic');
FFConfig config = new FFConfig.builder()
    .cache(cache)
    .metricsEnabled() //Enable Metrics publishing
    .build();

// Create Client
FFClient client = FFClient.builder('Your SDK Key', config).build();

// Set up the target properties.
FFTarget target = FFTarget.builder().identifier('Harness').name('Harness').build();

// Bool evaluation
Boolean value = client.boolVariation(flag, target, false);
System.debug('Feature flag ' + flag + ' is '+ value + ' for this user');
```

### Regular Polling
The SDKs uses a polling strategy to keep the local cache in sync with the flag configurations.
Since version 0.1.3, the poller will ensure that the SDK's authentication is refreshed before the token
is removed from your Platform Cache via its TTL. This is beneficial when you have scheduled jobs that are
using the FFClient, but the SDK has not been re-initialized recently outside of a scheduled job.

```apex
// set cache Namespace and Partition
FFOrgCache cache = new FFOrgCache('local', 'basic');
FFConfig config = new FFConfig.builder()
    .cache(cache)
    .build();

// Start Polling to update the cache
FFClient.builder('Your SDK Key', config)
    .withPolling(60) // Poll every 60 seconds
    .build();
```
Default Setting: This feature is disabled by default and must be explicitly enabled if needed.

**Warning**: If polling is not enabled, then the SDK will not be able to receive updated flag configuration. 
If you only want to receive the initial flag configuration, you can leave polling disabled and use the `FFClient.builder.withWaitForInitialized(true)` option. See
[Immediate Flag and Segment Fetching (Not Suitable for Scheduled Jobs)](#immediate-flag-and-segment-fetching-not-suitable-for-scheduled-jobs)

### Immediate Flag and Segment Fetching (Not Suitable for Scheduled Jobs)
To ensure the FFClient provides accurate evaluations right after initialization, you can use withWaitForInitialized(true). This method triggers an immediate cache refresh via a callout, thus updating the cache before any evaluations are performed. Consequently, it also skips the first scheduled poll, as the cache is already up to date.

Default Setting: This feature is disabled by default and must be explicitly enabled if needed.

**Warning**: Avoid using this feature within scheduled jobs, as it may cause the job to fail due to the immediate callout.

```apex
// set cache Namespace and Partition
FFOrgCache cache = new FFOrgCache('local', 'basic');
FFConfig config = new FFConfig.builder()
    .cache(cache)
    .build();

// Start Polling to update the cache
FFClient.builder('Your SDK Key', config)
    .withWaitForInitialized(true) // Fetch flags immediately
    .withPolling(60) // Poll every 60 seconds
    .build();
```

### Running the example

```bash
sfdx force:apex:execute --targetusername='YOUR TARGET ORG' --apexcodefile='YOUR_FILENAME.apex'
```

### Additional Reading

For further examples and config options, see the [APEX SDK Reference](https://docs.harness.io/article/aoe0y33mut-apex-sdk-reference).

For more information about Feature Flags, see our [Feature Flags documentation](https://ngdocs.harness.io/article/0a2u2ppp8s-getting-started-with-feature-flags).

-------------------------
[Harness](https://www.harness.io/) is a feature management platform that helps teams to build better software and to
test features quicker.

-------------------------
