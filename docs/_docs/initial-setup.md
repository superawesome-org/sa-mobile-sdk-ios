---
title: Initialise the SDK
description: Initialise the SDK
---

# Initialise the SDK

The first thing you’ll need to do after adding the SDK is to initialise it in the AppDelegate class of your iOS app.

{% highlight objective_c %}
#import "AwesomeAds.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [AwesomeAds initSDK:false];

  return YES;
}
{% endhighlight %}

Where the initSDK method takes a boolean parameter indicating whether logging is enabled or not. For production environments logging should be off.