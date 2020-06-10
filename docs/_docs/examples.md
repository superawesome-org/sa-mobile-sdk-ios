---
title: Examples
description: Examples
---

# Simple example

The first example shows how you can add a banner ad in your app with just a few lines of code.

{% highlight objective_c %}
#import "SuperAwesome.h"

@interface MyViewController()
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@end

@implementation MyViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    // setup the banner
    [_bannerAd disableParentalGate];
    [_bannerAd enableBumperPage];

    // add a callback
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
        // when the ad loads, play it directly
        if (event == adLoaded) {
            [_bannerAd play];
        }
    }];

    // start the loading process
    [_bannerAd load:30471];
}

@end
{% endhighlight %}

## Complex example

This example shows how you can add different types of ads and make them respond to multiple callbacks.

{% highlight objective_c %}
#import "SuperAwesome.h"

@interface MyViewController()
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@end

@implementation MyViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    // setup the banner
    [_bannerAd enableParentalGate];
    [_bannerAd disableBumperPage];

    // and load it
    [_bannerAd load:30471];

    // setup the video
    [SAVideoAd disableParentalGate];
    [SAVideoAd enableBumperPage];
    [SAVideoAd disableCloseButton];

    // load
    [SAVideoAd load:30479];
    [SAVideoAd load:30480];
}

@IBAction void playBanner {

    if ([_banner hasAdAvailable]) {
        [_banner play];
    }
}

@IBAction void playVideo1 {

    if ([SAVideoAd hasAdAvailable: 30479]) {

        // do some last minute setup
        [SAVideoAd setOrientationLandscape];

        // and play
        [SAVideoAd play: 30479 fromVC: self];
    }
}

@IBAction void playVideo2 {

    if ([SAVideoAd hasAdAvailable: 30480]) {

        // do some last minute setup
        [SAVideoAd setOrientationAny];

        // and play
        [SAVideoAd play: 30480 fromVC: self];
    }
}

@end
{% endhighlight %}