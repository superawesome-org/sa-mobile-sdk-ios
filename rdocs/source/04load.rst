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

    @interface MyViewController()

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    @end

    @implementation MyViewController

    - (void) viewDidLoad {
        [super viewDidLoad];

        // configure SDK to test mode
        [[SuperAwesome getInstance] enableTestMode];

        // create loader and load ad
        _loader = [[SALoader alloc] init];
        [_loader loadAdForPlacementId: 30471];

    }

    @end

The **loadAdForPlacementId:** function loads data asynchronously, so as not to block the main UI thread.
When it's done, it calls two important callback methods, **didLoadAd:** and **didFailToLoadAdForPlacementId:**,
to notify you of either success or failure.
In order to use these callbacks:

* your ViewController must implement the **SALoaderProtocol**

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>
    @end

* the ViewController must be set as delegate for the SALoader object created earlier

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    @end

    @implementation MyViewController

    - (void) viewDidLoad {
        [super viewDidLoad];

        // configure SDK to test mode
        [[SuperAwesome getInstance] enableTestMode];

        // create loader and load ad
        _loader = [[SALoader alloc] init];
        _loader.delegate = self;
        [_loader loadAdForPlacementId: 30471];
    }

    @end

* finally, your ViewController must also implement the two callback methods mentioned above, similarly to how UITableViewController and UITableViewDataSource works.

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    @end

    @implementation MyViewController

    - (void) viewDidLoad {
        [super viewDidLoad];

        // configure SDK to test mode
        [[SuperAwesome getInstance] enableTestMode];

        // create loader and load ad
        _loader = [[SALoader alloc] init];
        _loader.delegate = self;
        [_loader loadAdForPlacementId: 30471];

    }

    - (void) didLoadAd:(SAAd *)ad {
        // at this moment ad data is ready
        [ad print];
    }

    - (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
        // at this moment no ad could be found
    }

    @end

You'll notice that didLoadAd: has a callback parameter of type **SAAd**. The SAAd class contains all the information needed to
actually display an ad, such as format (image, video), dimensions, click URL, video information, creative details, etc.
You can find out all details by calling the **print** function, as shown in the example.

Saving an Ad for later use
^^^^^^^^^^^^^^^^^^^^^^^^^^

To save ads for later use, you can do something like this:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    // declare a SAAd object to save data in
    @property (nonatomic, strong) SAAd *bannerAdData;

    @end

    @implementation MyViewController

    - (void) viewDidLoad {
        [super viewDidLoad];

        // configure SDK to test mode
        [[SuperAwesome getInstance] enableTestMode];

        // create loader and load ad
        _loader = [[SALoader alloc] init];
        _loader.delegate = self;
        [_loader loadAdForPlacementId: 30471];
    }

    - (void) didLoadAd:(SAAd *)ad {
        // save the ad data for later use
        _bannerAdData = ad;
    }

    - (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
        // handle error case
    }

    @end

Saving multiple Ads for later use
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Finally, if you want to load multiple ads and save them for later use, you can do as such:

.. code-block:: objective-c

    @interface MyViewController () <SALoaderProtocol>

    // loader object
    @property (nonatomic, strong) SALoader *loader;

    // declare three SAAD objects to save ad data in
    @property (nonatomic, strong) SAAd *bannerAdData;
    @property (nonatomic, strong) SAAd *interstitialAdData;
    @property (nonatomic, strong) SAAd *videoAdData;

    @end

    @implementation MyViewController

    - (void) viewDidLoad {
        [super viewDidLoad];

        // configure SDK to test mode
        [[SuperAwesome getInstance] enableTestMode];

        // create loader and set delegate
        _loader = [[SALoader alloc] init];
        _loader.delegate = self;

        // load ad data for a banner
        [_loader loadAdForPlacementId: 30471];
        // load ad data for an interstitial
        [_loader loadAdForPlacementId: 30473];
        // load ad data for a video
        [_loader loadAdForPlacementId: 30479];

    }

    - (void) didLoadAd:(SAAd *)ad {

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
        NSLog("Failed to load ad data for %ld", placementId);
    }

    @end
