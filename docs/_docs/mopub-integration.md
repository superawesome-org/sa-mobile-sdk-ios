---
title: Integrate with MoPub
description: Integrate with MoPub
---

# Integrate with MoPub

If you already have MoPub ads serving in your app, but want to integrate AwesomeAds as well, without having to directly use the iOS Publisher SDK, you can follow the steps below:

## Add the MoPub plugin

Change your <strong>Podfile</strong> to contain the following:

{% highlight shell %}
target 'MyProject' do
    # add the SuperAwesome SDK
    pod 'SuperAwesome', '~> 7.2'

    # add the MoPub plugin
    pod 'SuperAwesome/MoPub', '~> 7.2'
end
{% endhighlight %}

and execute

{% highlight shell %}
pod update
{% endhighlight %}

## Setup Custom Networks

Login to the MoPub dashboard using your preferred account.

From here forward the tutorial assumes you have an iOS app with three ad units setup in MoPub; one banner, one interstitial ad and one rewarded video ad:

![image-title-here]({{ site.baseurl }}/assets/img/IMG_07_MoPub_0.png){:class="img-responsive"}

From your MoPub admin interface you should create a `New Order`

![image-title-here]({{ site.baseurl }}/assets/img/mopub-create-order.png){:class="img-responsive"}

From the next menu, select `New line item`

![image-title-here]({{ site.baseurl }}/assets/img/mopub-line-item.png){:class="img-responsive"}

Notice that the custom event class names required by MoPub are:
 - <strong>for Banner Ads:</strong>
 
 `SuperAwesome.AwesomeAdsMoPubBannerAdapter`
 - <strong>for Interstitial Ads:</strong> 
 
 `SuperAwesome.AwesomeAdsMoPubInterstitialAdapter`
 - <strong>for Rewarded Video Ads:</strong> 
 
 `SuperAwesome.AwesomeAdsMoPubVideoAdapter`

And, you can tell MoPub what AwesomeAds ads to load and how to display them by filling out the custom event class data field with a JSON similar to this:

```json
{
    "placementId": 30473,
    "isTestEnabled": true or false,
    "isParentalGateEnabled": true or false,
    "orientation": "ANY" or "PORTRAIT" or "LANDSCAPE",
    "shouldShowCloseButton": false or false,
    "shouldAutomaticallyCloseAtEnd": true or false,
    "shouldShowSmallClickButton": true or false
}
```

- In the second tab `Ad unit targeting`, <strong>Select</strong> your App&ad unit e.g. Banner

- In the third tab `Audience targetting`, <strong>Select</strong> your target audience

*Create multiple line items for banner, interstitial, and video(rewarded) ads.

{% include alert.html type="warning" title="Note" content="To test your adapter integration, you can disable other networks and only enable `AwesomeAds` line items to see if they are being served in your app." %}

## Implement Ads

Initialise the `MoPub` sdk with <strong>AwesomeAds</strong> adapter configuration

```swift
let configuration = MPMoPubConfiguration.init(adUnitIdForAppInitialization: bannerAdId)
        configuration.loggingLevel = .debug
        configuration.additionalNetworks = [AwesomeAdsMoPubAdapterConfiguration.self]
                
        MoPub.sharedInstance().initializeSdk(with: configuration) {
            print("MoPub SDK initialisation complete")
            
            self.configureBanner()
            self.configureInterstitial()
            self.configureVideo()
        }
```

Once the previous steps are done, you can add MoPub banners, interstitials and rewarded video ads just as you normally would:

 - <strong>for Banner Ads:</strong>
 [Banners](https://developers.mopub.com/publishers/ios/banner/)
 
 - <strong>for Interstitial Ads:</strong> 
 [Interstitials](https://developers.mopub.com/publishers/ios/interstitial/)

 - <strong>for Rewarded Video Ads:</strong> 
 [Rewarded Video](https://developers.mopub.com/publishers/ios/rewarded-video/)

Since the previously created custom events will run on these ads, and the iOS Publisher SDK is integrated alongside the MoPub plugin, you should start seeing ads playing.