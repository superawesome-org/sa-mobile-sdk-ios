Callbacks
=========

Once an ad starts playing, it will send back callbacks to notify you that it has finished different lifecycle activities.
To respond to them we'll use a similar protocol / delegate pattern as with SALoaderProtocol.

Standard ad callbacks
^^^^^^^^^^^^^^^^^^^^^

To catch standard ad callbacks:

* your ViewController must implement the **SAAdProtocol**:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol, SAAdProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    // SAAd and display object
    @property (nonatomic, strong) SAAd *bannerAdData;
    @property (nonatomic, strong) SABannerAd *banner;

    @end

* the ViewController must be set as delegate for your display objects:

.. code-block:: objective-c

    @implementation MyViewController

    // rest of your implementation ...

    - (IBAction) showBanner:(id)sender {

        CGRect top = CGRectMake(0, 0, 320, 50);

        if (_bannerAdData) {
            _banner = [[SABannerAd alloc] initWithFrame:top];
            [_banner setAd:_bannerAdData];
            [_banner setAdDelegate:self];
            [self.view addSubview:_banner];
            [_banner play];
        }
    }

    @end

* your ViewController must implement the callback methods specified by SAAdProtocol

.. code-block:: objective-c

    @implementation MyViewController

    // rest of the implementation ...

    - (void) adWasShown:(NSInteger)placementId {
        // this function is called when the ad
        // is shown on the screen
    }

    - (void) adFailedToShow:(NSInteger)placementId {
        // this function is called when the ad failed to show
    }

    - (void) adWasClosed:(NSInteger)placementId {
        // this function is called when an ad is closed;
        // only applies to fullscreen ads
        // like interstitials and fullscreen videos
    }

    - (void) adWasClicked:(NSInteger)placementId {
        // this function is called when an ad is clicked
    }

    - (void) adHasIncorrectPlacement:(NSInteger)placementId {
        // only called when setting an SAAd object
        // containing video data for a
        // banner type display object (or similar)
    }

    @end

Parental gate callbacks
^^^^^^^^^^^^^^^^^^^^^^^

To catch parental gate callbacks:

* Your View Controller must implement the **SAParentalGateProtocol**:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol, SAParentalGateProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    // SAAd and display object
    @property (nonatomic, strong) SAAd *bannerAdData;
    @property (nonatomic, strong) SABannerAd *banner;

    @end

* The ViewController again must be set as delegate for your display objects

.. code-block:: objective-c

    @implementation MyViewController

    // rest of your implementation ...

    - (IBAction) showBanner:(id)sender {

        CGRect top = CGRectMake(0, 0, 320, 50);

        if (_bannerAdData) {
            _banner = [[SABannerAd alloc] initWithFrame:top];
            [_banner setAd:_bannerAdData];
            [_banner setIsParentalGateEnabled: true];
            [_banner setParentalGateDelegate: self];
            [self.view addSubview:_banner];
            [_banner play];
        }
    }

    @end

* and it must implement the callback methods specified by SAParentalGateProtocol

.. code-block:: objective-c

    @implementation MyViewController

    // rest of the implementation ...

    - (void) parentalGateWasCanceled:(NSInteger)placementId {
        // this function is called when a
        // parental gate pop-up "cancel" button is pressed
    }

    - (void) parentalGateWasFailed:(NSInteger)placementId {
        // this function is called when a
        // parental gate pop-up "continue" button is
        // pressed and the parental gate
        // failed (because the numbers weren't OK)
    }

    - (void) parentalGateWasSucceded:(NSInteger)placementId {
        // this function is called when a
        // parental gate pop-up "continue" button is
        // pressed and the parental gate succeeded
    }

    @end

Video callbacks
^^^^^^^^^^^^^^^

To catch video ad callbacks (available only for SAVideoAd and SAFullscreenVideoAd objects):

* Your View Controller must implement the **SAVideoAdProtocol**:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol, SAVideoAdProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    // SAAd object and video ad display
    @property (nonatomic, strong) SAAd *videoAdData;
    @property (nonatomic, strong) SAVideoAd *video;

    @end

* The ViewController again must be set as delegate for your display objects

.. code-block:: objective-c

    @implementation MyViewController

    // rest of your implementation ...

    - (IBAction) showInLineVideo:(id)sender {

        CGRect frame = CGRectMake(0, 0, 480, 240);

        if (_videoAdData) {
            _video = [[SAVideoAd alloc] initWithFrame:frame];
            [_video setAd:_videoAdData];
            [_video setVideoDelegate:self];
            [self.view addSubview: _video];
            [_video play];
        }
    }

    @end

* and it must implement the callback methods specified by SAVideoAdProtocol

.. code-block:: objective-c

    @implementation MyViewController

    // rest of the implementation ...

    - (void) adStarted:(NSInteger)placementId {
        // fired when an ad has started
    }

    - (void) videoStarted:(NSInteger)placementId {
        // fired when a video ad has started
    }

    - (void) videoReachedFirstQuartile:(NSInteger)placementId {
        // fired when a video ad has reached 1/4 of total duration
    }

    - (void) videoReachedMidpoint:(NSInteger)placementId {
        // fired when a video ad has reached 1/2 of total duration
    }

    - (void) videoReachedThirdQuartile:(NSInteger)placementId {
        // fired when a video ad has reached 3/4 of total duration
    }

    - (void) videoEnded:(NSInteger)placementId {
        // fired when a video ad has ended
    }

    - (void) adEnded:(NSInteger)placementId {
        // fired when an ad has ended
    }

    - (void) allAdsEnded:(NSInteger)placementId {
        // fired when all ads have ended
    }

    @end
