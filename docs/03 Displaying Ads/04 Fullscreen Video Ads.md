In order to display Fullscreen Video ads, you'll need to change the code in the the `didLoadAd:` method you implemented earlier to this:

```
- (void) didLoadAd:(SAAd *)ad {
    SAFullscreenVideoAd *ad = [[SAFullscreenVideoAd alloc] init];
    [ad setAd:ad];
    [self presentViewController:ad animated:YES completion:^{
    	[ad play];
    }];
}

```
