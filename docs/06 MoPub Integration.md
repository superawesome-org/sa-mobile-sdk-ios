If you already have MoPub ads serving in your app, but want to integrate SuperAwesome as well, without having to directly use the AwesomeAds SDK, you can follow the steps below:

#### Integrate the SDK

The first thing you should do is integrate the SDK in your current app:

If you haven't already, install [CocoaPods](http://cocoapods.org).

```
sudo gem install cocoapods

```

After that you need to go to the project's directory and initialize CocoaPods

```
cd /project_root
pod init

```

Then open and edit the `Podfile` so it looks something similar to the following:

```
# Uncomment this line to define a global platform for your project
platform :ios, '6.0'

target 'MyProject' do
  pod 'SuperAwesome/MoPub'
end

```

After the pod source has been added, update your project's dependencies by running the following command in the terminal:

```
pod update

```

This will automatically add the SDK to your current project, add MoPub adapters and resolve all dependency issues.
The MoPub adapters CocoaPods will download are:

  * [SuperAwesomeBannerCustomEvent](https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios/blob/master/Pod/Plugin/MoPub/SuperAwesomeBannerCustomEvent.h)
  * [SuperAwesomeInterstitialCustomEvent](https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios/blob/master/Pod/Plugin/MoPub/SuperAwesomeInterstitialCustomEvent.h)
  * [SuperAwesomeRewardedVideoCustomEvent](https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios/blob/master/Pod/Plugin/MoPub/SuperAwesomeRewardedVideoCustomEvent.h)


#### Setup a MoPub Custom Network

From your MoPub admin interface you should create a `New Network`

![](img/IMG_07_MoPub_1.png "Adding a new Network")

Form the next menu, select `Custom Native Network`

![](img/IMG_07_MoPub_2.png "Creating a Custom Native Network")

You'll be taken to a new page. Here select the title of the new network

![](img/IMG_07_MoPub_3.png "Create the Super Awesome Network")

And assign custom inventory details for Banner and Interstitial ads:

![](img/IMG_07_MoPub_4.png "Setup custom inventory")

Custom Event Class is:
  * for Banner Ads: `SuperAwesomeBannerCustomEvent`
  * for Interstitial Ads: `SuperAwesomeInterstitialCustomEvent`
  * for Rewarded Video Ads: `SuperAwesomeRewardedVideoCustomEvent`

Notice these are identical to the names of the four files you downloaded in step one.

Custom Event Data that is always required, and must be given in the form of  JSON:

```
{
	"placementId": 5692,
	"isTestEnabled": true,
	"isParentalGateEnabled": true
}

```

Optional Event Data for Rewarded Videos is:

```
{
  "shouldShowCloseButton": false,
  "shouldAutomaticallyCloseAtEnd": true
}

```

If you don't yet have a Placement ID for Awesome Ads, check out the [Getting Started / Registering Your App on the Dashboard](https://developers.superawesome.tv/docs/iossdk/Getting%20Started/Registering%20Your%20App%20on%20the%20Dashboard?version=4) section.
