Loading ads
===========

After setting up the SDK, the first thing you'll want to do is start loading ads.

With AwesomeAds, this is simple:

.. code-block:: objective-c

    @interface MyViewController ()

    // you can start loading ads in your View Controller's init method,
    // for example
    - (id) init {
      if (self = [super init]) {

        // create a new SALoader object
        SALoader *loader = [[SALoader alloc] init];

        // call it's loadAdForPlacementId method
        // any placement for any kind of ad can be loaded like this
        [loader loadAdForPlacementId: 5740];
      }

      return self;
    }

    @end

The code above does load an ad, but by itself it does not allow you to be notified of when the ad data is actually loaded.
To do so, you'll need to make your View Controller conform to the **SALoaderProtocol**, much the same way you'd conform to the
UITableViewDelegate or UITableViewDataSource protocols.

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>
      // the rest of your implementation
    @end


Finally, the SALoaderProtocol defines two methods that need to be implemented:

.. code-block:: objective-c

    - (void) didLoadAd:(SAAd *)ad {
      // at this moment the ad data is loaded and ready
      // to be used to display ad contents
      //
      // you can check that all is OK by using the ad's "print" function
      [ad print];
    }

    - (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
      // handle error case
    }

When **didLoadAd:** gets called, the ad data is completely loaded.

Finally, the SALoader object you've just created must set it's delegate to the current View Controller:

.. code-block :: objective-c

    [loader setDelegate: self];
