---
title: Video Ads
description: Video Ads
---

# Video Ads

The following code block sets up a video ad and loads it:

{% highlight swift %}

override func viewDidLoad() {
    super.viewDidLoad()

    // set whole video surface clickable
    VideoAd.disableSmallClickButton()

    // deprecated: set config to production. Use `AwesomeAds.initSDK()` to select the configuration instead.
    VideoAd.setConfigurationProduction()

    // to display test ads
    VideoAd.enableTestMode()

    // lock orientation to portrait or landscape
    VideoAd.setOrientationPortrait()

    // enable or disable a close button
    VideoAd.enableCloseButton()

    // enable or disable a close button that displays without a delay. Use instead of enableCloseButton.
    // WARNING: this will allow users to close the ad before the viewable tracking event is fired
    // and should only be used if you explicitly want this behaviour over consistent tracking.
    VideoAd.enableCloseButtonNoDelay()
    
    // enable close button and warn user before closing
    VideoAd.enableCloseButtonWithWarning()

    // enable or disable auto-closing at the end
    VideoAd.disableCloseAtEnd()
    
    // mute the video on start
    VideoAd.enableMuteOnStart()

    // start loading ad data for a placement
    VideoAd.load(30479)
}
{% endhighlight %}

Once you’ve loaded an ad, you can display it by checking if the ad has loaded using a callback:

{% highlight swift %}
VideoAd.setCallback { (placementId, event) in
    if event == .adLoaded {
        VideoAd.play(withPlacementId: placementId, fromVc: self)
    }
}
{% endhighlight %}

Or by checking the method hasAdAvailable which returns a Boolean:

{% highlight swift %}
if VideoAd.hasAdAvailable(30479) {
    ...
}
{% endhighlight %}

These are the default values:

| Parameter | Value |
|-----|-----|
| Configuration | Production |
| Test mode | Disabled |
| Orientation | Any | 
| Closes at end | True |
| Close button | Disabled |
| Small click button | Disabled | 
| Close button with no delay | Disabled |
| Close with warning | Disabled |
| Mute on start | Disabled |

{% include alert.html type="info" title="Note" content="When locking orientation with either the <strong>setOrientationPortrait</strong> or <strong>setOrientationLandscape</strong> methods, the SDK will first look at the list of orientations supported by your app and conform to that. If, for example, you set an interstitial ad to display in landscape mode but your app only supports portrait orientations, the ad will show in portrait mode." %}
