Loading ads
===========

After you've created your Apps and Placements in the dashboard and successfully integrated the SDK in your project,
the next logical step is to actually start showing ads.

For this purpose, the SDK employs a two-step process:
First, you'll need to load ad data for each placement you'll want to display.
Then, once that data is successfully loaded, you can finally show the ad.
The two steps are independent of each other so you can easily pre-load ads for later use, saving performance.

In the code snippet below we'll start by loading data for the test placement **30471**.
A good place to do this is in a ViewController's **init** function,
where we'll create a **SALoader** object to help us.

SALoader is a SDK class whose sole role is to load, parse, process and validate ad data.
You'll usually need just one instance per ViewController.

.. code-block:: objective-c

    @implementation MyViewController

    - (id) init {
      if (self = [super init]) {

        SALoader *loader = [[SALoader alloc] init];
        [loader loadAdForPlacementId: 30471];
      }

      return self;
    }

    @end

The **loadAdForPlacementId:** function loads data asynchronously, so as not to block the main UI thread.
When it's done, it calls two important callback methods, **didLoadAd:** and **didFailToLoadAdForPlacementId:**,
to notify you of either success or failure.
In order to use these callbacks:

* your ViewController must implement the **SALoaderProtocol**

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>
    // rest of your code ...
    @end

* the ViewController must be set as delegate for the SALoader object created earlier

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>
    @end

    @implementation MyViewController

    - (id) init {
      if (self = [super init]){
        SALoader *loader = [[SALoader alloc] init];
        loader.delegate = self;
        [loader loadAdForPlacementId: 30471];
      }

      return self;
    }

    @end

* finally, your ViewController must also implement the two callback methods mentioned above, similarly to how UITableViewController and UITableViewDataSource works.

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>
    @end

    @implementation MyViewController
    // rest of your implementation ...

    - (void) didLoadAd:(SAAd *)ad {
      // at this moment ad data is ready
      [ad print];
    }

    - (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
      // handle error case
    }

    @end

You'll notice that didLoadAd: has a callback parameter of type **SAAd**. The SAAd class contains all the information needed to
actually display an ad, such as format (image, video), dimensions, click URL, video information, creative details, etc.
You can find out all details by calling the **print** function, as shown in the example.

Knowing this, to save ads for later use, you can do something like this:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>
    @property (nonatomic, strong) SAAd *bannerAdData;
    @end

    @implementation MyViewController
    // rest of your implementation ...

    - (void) didLoadAd:(SAAd *)ad {
      // save the ad data for later use
      _myAdData = ad;
    }

    @end

Finally, if you want to load multiple ads and save them for later use, you can do as such:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>
    @property (nonatomic, strong) SAAd *bannerAdData;
    @property (nonatomic, strong) SAAd *interstitialAdData;
    @property (nonatomic, strong) SAAd *videoAdData;
    @end

    @implementation MyViewController

    - (id) init {
      if (self = [super init]) {
        SALoader *loader = [[SALoader alloc] init];
        loader.delegate = self;

        // load ad data for a banner
        [loader loadAdForPlacementId: 30471];
        // load ad data for an interstitial
        [loader loadAdForPlacementId: 30473];
        // load ad data for a video
        [loader loadAdForPlacementId: 30479];
      }

      return self;
    }

    - (void) didLoadAd:(SAAd *)ad {
      if (ad.placementId == 30471) {
        _bannerAdData = ad;
      } else if (ad.placementId == 30473) {
        _interstitialAdData = ad;
      } else if (ad.videoAdData == 30479) {
        _videoAdData = ad;
      }
    }

    - (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
      NSLog("Failed to load ad data for %ld", placementId);
    }

    @end
