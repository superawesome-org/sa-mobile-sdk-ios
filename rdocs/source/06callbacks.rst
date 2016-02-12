Callbacks
=========

Once an ad starts playing, it will also send back callbacks to notify you when it's finished different activities.
To respond to them we'll use a similar protocol / delegate pattern to SALoaderProtocol.

Standard ad callbacks
^^^^^^^^^^^^^^^^^^^^^

To catch standard ad callbacks:

* your ViewController must implement the **SAAdProtocol**:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocl, SAAdProtocol>
    @property (nonatomic, strong) SAAd *bannerAdData;
    @property (nonatomic, strong) SABannerAd *banner;
    @end

* the ViewController must be set as delegate for your SABannerAd, SAInterstitialAd or SAFullscreenVideoAd objects:

.. code-block:: objective-c

    @implementation MyViewController
    // rest of your implementation ...

      - (IBAction) showBanner {

        CGRect top = CGRectMake(0, 0, 320, 50);
        _banner = [[SABannerAd alloc] initWithFrame:top];

        [_banner setAdDelegate:self]; // set the delegate

        [self.view addSubview:_banner];
        [_banner play];
      }

    @end

* your ViewController must implement the callback methods specified by SAAdProtocol

.. code-block:: objective-c

    @implementation MyViewController
    // rest of the implementation ... 

      // this function is called when the ad is shown on the screen
      - (void) adWasShown:(NSInteger)placementId {

      }

      // this function is called when the ad failed to show
      - (void) adFailedToShow:(NSInteger)placementId {

      }

      // this function is called when an ad is closed;
      // only applies to fullscreen ads like interstitials and fullscreen videos
      - (void) adWasClosed:(NSInteger)placementId {

      }

      // this function is called when an ad is clicked
      - (void) adWasClicked:(NSInteger)placementId {

      }

    @end

Parental gate callbacks
^^^^^^^^^^^^^^^^^^^^^^^

Additionally, you can implement the **SAParentalGateProtocol** to capture parental gate events:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol, SAParentalGateprotocol>

      // rest of your implementation
      // ....

      // this function is called when a parental gate pop-up "cancel" button is pressed
      - (void) parentalGateWasCanceled:(NSInteger)placementId {

      }

	    // this function is called when a parental gate pop-up "continue" button is
	    // pressed and the parental gate failed (because the numbers weren't OK)
	    - (void) parentalGateWasFailed:(NSInteger)placementId {

	    }

	    // this function is called when a parental gate pop-up "continue" button is
	    // pressed and the parental gate succeeded
	    - (void) parentalGateWasSucceded:(NSInteger)placementId {

      }

    @end

And just as before, any ads in your app must set their **parentalGateDelegate** object to **MyViewController**,
as the class that implements the SAParentalGateProtocol interface.

.. code-block:: objective-c

    video = [[SAVideoAd alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    // where "self" is the view controller
    [video setParentalGateDelegate: self];


Video callbacks
^^^^^^^^^^^^^^^
