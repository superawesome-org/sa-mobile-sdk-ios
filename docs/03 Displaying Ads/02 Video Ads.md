In order to display Video ads, you'll need to change the code in the the `didLoadAd:` method you implemented earlier to this:

```
- (void) didLoadAd:(SAAd *)ad {
    SAVideoAd *ad = [[SAVideoAd alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [ad setAd:ad];
    [self.view addSubview: ad];
    [ad play];
}

```
