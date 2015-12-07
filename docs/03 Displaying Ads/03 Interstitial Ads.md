In order to display Interstitial ads, you'll need to change the code in the the `didLoadAd:` method you implemented earlier to this:

```
- (void) didLoadAd:(SAAd *)ad {
    SAInterstitialAd *ad = [[SAInterstitialAd alloc] init];
    [ad setAd:ad];
    [self presentViewController:ad animated:YES completion:^{
    	[ad play];
    }];
}

```
