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

Notice that the custom event classes required by MoPub are:
 - for Banner Ads: SAMoPubBannerCustomEvent
 - for Interstitial Ads: SAMoPubInterstitialCustomEvent
 - for Rewarded Video Ads: SAMoPubVideoCustomEvent

Finally, you can tell MoPub what AwesomeAds ads to load and how to display them by filling out the custom event class data field with a JSON similar to this:

{% highlight json %}
{
    "placementId": 30473,
    "isTestEnabled": true or false,
    "isParentalGateEnabled": true or false,
    "orientation": "ANY" or "PORTRAIT" or "LANDSCAPE",
    "shouldShowCloseButton": false or false,
    "shouldAutomaticallyCloseAtEnd": true or false,
    "shouldShowSmallClickButton": true or false
}
{% endhighlight %}

## Implement Ads

Once the previous steps are done, you can add MoPub banners, interstitials and rewarded video ads just as you normally would:

{% highlight objective_c %}
// create & load banner
MPAdView *banner = [[MPAdView alloc] initWithAdUnitId:@"_AD_UNIT_ID_"
        size:MOPUB_BANNER_SIZE];
banner.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
[self.view addSubview: banner];
[banner loadAd];

// create & load interstitial
MPInterstitialAdController *interstitial =
        [MPInterstitialAdController interstitialAdControllerForAdUnitId: @"_AD_UNIT_ID_"];
[interstitial loadAd];

// load video ads
[[MoPub sharedInstance]
        initializeRewardedVideoWithGlobalMediationSettings: nil
        delegate: self];
[MPRewardedVideo
        loadRewardedVideoAdWithAdUnitID: @"_AD_UNIT_ID_"
        withMediationSettings: nil];
{% endhighlight %}

Since the previously created custom events will run on these ads, and AwesomeAds is integrated alongside the MoPub plugin, you should start seeing ads playing.