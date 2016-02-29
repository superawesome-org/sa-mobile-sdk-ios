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
    @property (nonatomic, strong) SAAd *bannerAdData;
    @property (nonatomic, strong) SABannerAd *banner;
    @end

* the ViewController must be set as delegate for your display objects:

.. code-block:: objective-c

    @implementation MyViewController
    // rest of your implementation ...

    - (IBAction) showBanner {

      CGRect top = CGRectMake(0, 0, 320, 50);
      _banner = [[SABannerAd alloc] initWithFrame:top];

      // set the delegate
      [_banner setAdDelegate:self];

      [self.view addSubview:_banner];
      [_banner play];
    }

    @end

* your ViewController must implement the callback methods specified by SAAdProtocol

.. code-block:: objective-c

    @implementation MyViewController
    // rest of the implementation ...

    // this function is called when the ad
    // is shown on the screen
    - (void) adWasShown:(NSInteger)placementId {

    }

    // this function is called when the ad failed to show
    - (void) adFailedToShow:(NSInteger)placementId {

    }

    // this function is called when an ad is closed;
    // only applies to fullscreen ads
    // like interstitials and fullscreen videos
    - (void) adWasClosed:(NSInteger)placementId {

    }

    // this function is called when an ad is clicked
    - (void) adWasClicked:(NSInteger)placementId {

    }

    // only called when setting an SAAd object
    // containing video data for a
    // banner type display object (or similar)
    - (void) adHasIncorrectPlacement:(NSInteger)placementId {

    }

    @end

Parental gate callbacks
^^^^^^^^^^^^^^^^^^^^^^^

To catch parental gate callbacks:

* Your View Controller must implement the **SAParentalGateProtocol**:

.. code-block:: objective-c

    @interface MyViewController ()
    <SALoaderProtocol, SAAdProtocol, SAParentalGateProtocol>
    // rest of your implementation ..
    @end

* The ViewController again must be set as delegate for your display objects

.. code-block:: objective-c

    // rest of your code ...
    // ...
    [_banner setIsParentalGateEnabled: true];
    [_banner setParentalGateDelegate: self];

* and it must implement the callback methods specified by SAParentalGateProtocol

.. code-block:: objective-c

    // this function is called when a
    // parental gate pop-up "cancel" button is pressed
    - (void) parentalGateWasCanceled:(NSInteger)placementId {

    }

    // this function is called when a
    // parental gate pop-up "continue" button is
    // pressed and the parental gate
    // failed (because the numbers weren't OK)
    - (void) parentalGateWasFailed:(NSInteger)placementId {

    }

    // this function is called when a
    // parental gate pop-up "continue" button is
    // pressed and the parental gate succeeded
    - (void) parentalGateWasSucceded:(NSInteger)placementId {

    }

    @end

Video callbacks
^^^^^^^^^^^^^^^

To catch video ad callbacks (available only for SAVideoAd and SAFullscreenVideoAd objects):

* Your View Controller must implement the **SAVideoAdProtocol**:

.. code-block:: objective-c

    @interface MyViewController ()
    <SALoaderProtocol, SAAdProtocol, SAParentalGateProtocol, SAVideoAdProtocol>
    // rest of your implementation ..
    @end

* The ViewController again must be set as delegate for your display objects

.. code-block:: objective-c

    // rest of your code ...
    // ...
    [_video setVideoDelegate:self];

* and it must implement the callback methods specified by SAVideoAdProtocol

.. code-block:: objective-c

    // fired when an ad has started
    - (void) adStarted:(NSInteger)placementId {

    }

    // fired when a video ad has started
    - (void) videoStarted:(NSInteger)placementId {

    }

    // fired when a video ad has reached 1/4 of total duration
    - (void) videoReachedFirstQuartile:(NSInteger)placementId {

    }

    // fired when a video ad has reached 1/2 of total duration
    - (void) videoReachedMidpoint:(NSInteger)placementId {

    }

    // fired when a video ad has reached 3/4 of total duration
    - (void) videoReachedThirdQuartile:(NSInteger)placementId {

    }

    // fired when a video ad has ended
    - (void) videoEnded:(NSInteger)placementId {

    }

    // fired when an ad has ended
    - (void) adEnded:(NSInteger)placementId {

    }

    // fired when all ads have ended
    - (void) allAdsEnded:(NSInteger)placementId {

    }

    @end
