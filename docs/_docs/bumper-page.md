---
title: Bumper page
description: Bumper page
---

# Bumper page

This section will show how to use the bumper element and how to customise it.

The Bumper is an optional UI dialog that informs the user that they are about to leave a kid-safe place and proceed to an external website.

In technical terms when a user clicks on an ad placement a bumper popup will be presented for a duration of 3 seconds informing that the user will be redirected to a external source.

SuperAwesome’s kid-safe review team will always configure the bumper when:
 - An ad links to a social media site, eg YouTube, Facebook, etc.
 - An ad links to a retailer or online shop

## Bumper customisation

 It is possible to customise the bumper in following ways:
  1. Add a custom name
  2. Add a custom logo

### 1. Bumper customisation - custom name

In order to override the name on the bumper dialog, please use the following code:

{% highlight objective_c %}
// customize the name displayed on the bumper page
[SABumperPage overrideName:@"__CUSTOM_APP_NAME__"];
{% endhighlight %}

### 2. Bumper customisation - custom logo

In order to override the logo on the bumper dialog, please use the following code:

{% highlight objective_c %}
// customize the logo displayed on the bumper page
[SABumperPage overrideLogo:[UIImage imageName:@"__MY_LOGO__"]];
{% endhighlight %}

By default the Bumper page will try to use the application name and the AwesomeAds logo and will look like following:

![image-title-here]({{ site.baseurl }}/assets/img/IMG_06_BumperPage.png){:class="img-responsive"}

## Forcing the bumper

Optionally, Publishers can choose for the bumper to always display when an ad is served on a placement. In order to enable the bumper, please use the following code:

{% highlight objective_c %}
// enable the Bumper page for a particular banner placement
[mybanner enableBumperPage];

// enable the Bumper page on all interstitial ads
[SAInterstitialAd enableBumperPage];

// enable the Bumper page on all video ads
[SAVideoAd enableBumperPage];
{% endhighlight %}

## Disabling the bumper

The bumper can subsequently be disabled using:

{% highlight objective_c %}
// disable the Bumper page for a particular banner placement
[mybanner disableBumperPage];

// disable the Bumper page on all interstitial ads
[SAInterstitialAd disableBumperPage];

// disable the Bumper page on all video ads
[SAVideoAd disableBumperPage];
{% endhighlight %}