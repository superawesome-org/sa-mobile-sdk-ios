---
title: Parental gate
description: Parental gate
---

# Parental gate

The Parental gate is an optional UI element you can add to your ad placements so that when a user clicks on an ad he is presented with a popup asking him to solve a simple math sum.

Its role is to prevent very young users from simply clicking on an ad and instead ask their parents for guidance.

A parental gate is mandatory on all external click throughs on apps in the kids category on iOS. This should be applied if your app is in this category and you do not have your own in use, to prevent your app being blocked by Apple.

You can enable it like so:

{% highlight objective_c %}
// enable Parental gate on one banner placement
[mybanner enableParentalGate];

// enable Parental gate on all interstitial ads
[SAInterstitialAd enableParentalGate];

// enable Parental gate on all video ads
[SAVideoAd enableParentalGate];
{% endhighlight %}

The final result will look something similar to this:

![image-title-here]({{ site.baseurl }}/assets/img/IMG_06_ParentalGate.png){:class="img-responsive"}

These are the default values:

| Parameter | Value |
|-----|-----|
| Parental gate | Disabled |