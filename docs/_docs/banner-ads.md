---
title: Banner Ads
description: Banner Ads
---

# Banner Ads

The following block of code creates and loads a banner ad:

{% highlight objective_c %}
@interface ViewController ()
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // to display test ads
    [_bannerAd enableTestMode];

    // set configuration production
    [_bannerAd setConfigurationProduction];

    // set background color transparent
    [_bannerAd setColorTransparent];

    // start loading ad data for a placement
    [_bannerAd load:30471];

}
{% endhighlight %}

Once you’ve loaded an ad, you can also display it:

{% highlight objective_c %}
@IBAction void onClick:(id) sender {

    // check if ad is loaded
    if ([banner hasAdAvailable]) {

        // display the ad
        [_bannerAd play];
    }
}
{% endhighlight %}

These are the default values:

| Parameter | Value |
|-----|-----|
| Configuration | Production |
| Test mode | Disabled |
| Background | Gray | 