Full Examples
=============

Simple Example
^^^^^^^^^^^^^^

The first example shows how you can add a banner ad in your app with just a
few lines of code.

.. code-block:: objective-c

    #import "SuperAwesome.h"

    @interface MyViewController() <SALoaderProtocol>
    @end

    @implementation MyViewController

    - (void) viewDidLoad {
        [super viewDidLoad];

        // configure SDK to test mode
        [[SuperAwesome getInstance] enableTestMode];

        // load ads
        SALoader *loader = [[SALoader alloc] init];
        loader.delegate = self;
        [loader loadAdForPlacementId: 30471];
    }

    - (void) didLoadAd:(SAAd *)ad {

        CGRect top = CGRectMake(0, 0, 320, 50);

        // create the banner
        SABannerAd *banner = [[SABannerAd alloc] initWithFrame:top];
        [banner setAd: ad];
        [self.view addSubview: banner];
        [banner play];
    }

    - (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
        NSLog("Failed to load for %ld", placementId);
    }

    @end

Complex Example
^^^^^^^^^^^^^^^

This example shows how you can add different types of ads and make them respond to
multiple callbacks.

.. code-block:: objective-c

    #import "SuperAwesome.h"

    @interface MyViewController()
    <SALoaderProtocol,
     SAAdProtocol,
     SAParentalGateProtocol,
     SAVideoAdProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    // retained SAAd objects to hold all types of ad data
    @property (nonatomic, strong) SAAd *bannerAdData;
    @property (nonatomic, strong) SAAd *interstitialAdData;
    @property (nonatomic, strong) SAAd *videoAdData;

    // retained display objects
    @property (nonatomic, strong) SABannerAd *banner;
    @property (nonatomic, strong) SAInterstitialAd *interstitial;
    @property (nonatomic, strong) SAFullscreenVideoAd *fvideo;
    @end

    @implementation MyViewController

    - (void) viewDidLoad {
        [super viewDidLoad];

        // additional setup ...
        [[SuperAwesome getInstance] enableTestMode];
    }

    //
    // Button actions

    - (IBAction) loadAds:(id)sender {

        // load three ads in a row!
        _loader = [[SALoader alloc] init];
        _loader.delegate = self;
        [_loader loadAdForPlacementId: 30471];
        [_loader loadAdForPlacementId: 30473];
        [_loader loadAdForPlacementId: 30479];
    }

    - (IBAction) showBanner:(id)sender {

        CGRect top = CGRectMake(0, 0, 320, 50);

        if (_bannerAdData) {
            _banner = [[SABannerAd alloc] initWithFrame:top];
            [_banner setAd: _bannerAdData];
            [_banner setAdDelegate:self];
            [_banner setIsParentalGateEnabled:true];
            [self.view addSubview: _banner];
            [_banner play];
        }
    }

    - (IBAction) showInterstitial:(id)sender {
        if (_interstitialAdData) {
            // init
            _interstitial = [[SAInterstitialAd alloc] init];
            [_interstitial setAd: _interstitialAdData];
            [_interstitial setIsParentalGateEnabled:true];
            [_interstitial setParentalGateDelegate:self];

            // add to screen
            [self presentViewController:_interstitial
                               animated:YES
                             completion:^{
                [_interstitial play];
            }];
        }
    }

    - (IBAction) showVideoAd:(id)sender {
        if (_videoAdData) {
            // init
            _fvideo = [[SAFullscreenVideoAd alloc] init];
            [_fvideo setAd:videoAdData];
            [_fvideo setVideoDelegate:self];
            [_fvideo setShouldAutomaticallyCloseAtEnd:false];
            [_fvideo setShouldShowCloseButton:false];

            // add to screen
            [self presentViewController:_fvideo
                               animated:YES
                             completion:^{
                [_fvideo play];
            }];
        }
    }

    //
    // SALoaderProtocol implementation

    - (void) didLoadAd:(SAAd *)ad {
        // the moment the ad data gets loaded from
        // the network, assign it to a specific retained property

        if (ad.placementId == 30471) {
            _bannerAdData = ad;
        }
        else if (ad.placementId == 30473) {
            _interstitialAdData = ad;
        }
        else if (ad.videoAdData == 30479) {
            _videoAdData = ad;
        }
    }

    - (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
        NSLog("Failed to load for %ld", placementId);
    }

    //
    // SAAdProtocol implementation

    - (void) adWasShown:(NSInteger)placementId {}
    - (void) adFailedToShow:(NSInteger)placementId {}
    - (void) adWasClosed:(NSInteger)placementId {}
    - (void) adWasClicked:(NSInteger)placementId {}
    - (void) adHasIncorrectPlacement:(NSInteger)placementId {
        NSLog("Ad has incorrect placement for %ld", placementId);
    }

    //
    // SAParentalGateProtocol implementation

    - (void) parentalGateWasCanceled:(NSInteger)placementId {}
    - (void) parentalGateWasFailed:(NSInteger)placementId {}
    - (void) parentalGateWasSucceded:(NSInteger)placementId {}

    //
    // SAVideoAdProtocol implementation

    - (void) adStarted:(NSInteger)placementId {}
    - (void) videoStarted:(NSInteger)placementId {}
    - (void) videoReachedFirstQuartile:(NSInteger)placementId {}
    - (void) videoReachedMidpoint:(NSInteger)placementId {}
    - (void) videoReachedThirdQuartile:(NSInteger)placementId {}
    - (void) videoEnded:(NSInteger)placementId {}
    - (void) adEnded:(NSInteger)placementId {}
    - (void) allAdsEnded:(NSInteger)placementId {
        // since we've set our video object's parameters to
        // not show a close button AND not automatically close
        // when all video ads have ended
        // we can manually close the video
        // once it's ended - here
        [_fvideo close];
    }

    @end
