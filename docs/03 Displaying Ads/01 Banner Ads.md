In order to display Banner ads, you'll need to change the code in the the `didLoadAd:` method you implemented earlier to this:

```
- (void) didLoadAd:(SAAd *)ad {
	// create a new banner with a fixed frame
    SABannerAd *banner = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];

    // set it's ad data
    [banner setAd:ad];

    // add it as a subview
    [self.view addSubview: banner];

    // play the banner (display the ad content)
    [banner play];
}

```
