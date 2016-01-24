In order to display Video ads, you'll need to change the code in the the `didLoadAd:` method you implemented earlier to this:

```
- (void) didLoadAd:(SAAd *)ad {
	// create a new video ad, with a specific frame
    SAVideoAd *video = [[SAVideoAd alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];

    // set the ad data
    [video setAd:ad];

    // add the video ad object as a subview 
    [self.view addSubview: video];

    // start playing it
    [video play];
}

```
