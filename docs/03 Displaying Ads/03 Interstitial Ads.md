In order to display Interstitial ads, you'll need to change the code in the the `didLoadAd:` method you implemented earlier to this:

```
- (void) didLoadAd:(SAAd *)ad {
	// init and alloc an interstitial ad
    SAInterstitialAd *interstitial = [[SAInterstitialAd alloc] init];

    // add the Ad data to the interstitial
    [interstitial setAd:ad];

    // assuming "self" is a ViewController, present the interstitial
    [self presentViewController:interstitial animated:YES completion:^{

    	// and once it's presented, play it
    	[interstitial play];
    }];
}

```
