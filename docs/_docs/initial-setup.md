---
title: Initialise the SDK
description: Initialise the SDK
---

# Initialise the SDK

The first thing you’ll need to do after adding the SDK is to initialise it in the AppDelegate class of your iOS app:

{% highlight swift %}
import UIKit
import SuperAwesome
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        AwesomeAds.initSDK(false)
    }
}
{% endhighlight %}

The initSDK method takes a boolean parameter indicating whether logging is enabled or not. For production environments logging should be off.

The SDK can also be initialised with a Configuration object and an optional callback that's called when the initialisation is complete:

{% highlight swift %}
import UIKit
import SuperAwesome
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        AwesomeAds.initSDK(configuration: Configuration(environment: .production, logging: true)) {
            print("AwesomeAds SDK init complete")
        }
    }
}
{% endhighlight %}

The Configuration object has 3 properties:

{% highlight swift %}
  let environment: Environment
  let logging: Bool
  let options: [String: String]?
{% endhighlight %}

The environment can be set to either production or staging, logging can be enabled or disabled (it should be disabled in production environments) and an optional options dictionary can be passed.
The options dictionary is used to set additional tracking information that will be sent when events are fired from the SDK in the form of key value pairs.

