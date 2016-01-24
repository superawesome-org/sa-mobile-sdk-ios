In order to display Fullscreen Video ads, you'll need to change the code in the the `didLoadAd:` method you implemented earlier to this:

```
- (void) didLoadAd:(SAAd *)ad {
	// alloc and init a new fullscreen video ad object
    SAFullscreenVideoAd *fullvideo = [[SAFullscreenVideoAd alloc] init];
    
    // set actual ad data for
    [fullvideo setAd:ad];

    // set parameters
    [fullvideo setShouldAutomaticallyCloseAtEnd:false];
    [fullvideo setShouldShowCloseButton:true];

    // assuming "self" is a ViewController, present the "fullvideo" object
    [self presentViewController:fullvideo animated:YES completion:^{

    	// and once it's presented, play the fullscreen ad
    	[fullvideo play];
    }];
}

```
