Display Ads
===========

The next four sections will deal with displaying ads once data is loaded.

Banner ads
^^^^^^^^^^

In order to display Banner ads, you'll need to change the code in the the **didLoadAd:** method you implemented earlier to this:

.. code-block:: objective-c

    - (void) didLoadAd:(SAAd *)ad {
      // create a new SABanner object with a fixed frame
      // the recommended initializer is initWithFrame:
      SABannerAd *banner = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];

      // you must always tell the SABanner object
      // what ad data to work with
      [banner setAd:ad];

      // add it as a subview
      [self.view addSubview: banner];

      // play the banner (display the ad content)
      [banner play];
    }

Video ads
^^^^^^^^^

Video ads follow the same principle.

.. code-block:: objective-c

    - (void) didLoadAd:(SAAd *)ad {
      // create a new SAVideoAd object
      // again the preferred initializer is initWithFrame:
      SAVideoAd *video = [[SAVideoAd alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];

      // set the ad data
      [video setAd:ad];

      // add the video ad object as a subview
      [self.view addSubview: video];

      // start playing it
      [video play];
    }

Interstitial ads
^^^^^^^^^^^^^^^^

Interstitial ads have a similar method of displaying.

.. code-block:: objective-c

    - (void) didLoadAd:(SAAd *)ad {
      // SAInterstitialAd objects are allocated and initialized
      // using the simple init function
      SAInterstitialAd *interstitial = [[SAInterstitialAd alloc] init];

      // add the Ad data to the interstitial
      [interstitial setAd:ad];

      // assuming "self" is a ViewController, present the interstitial
      [self presentViewController:interstitial animated:YES completion:^{
        // and once it's presented, play it
        [interstitial play];
      }];
    }

Fullscreen video ads
^^^^^^^^^^^^^^^^^^^^

Finally, fullscreen video ads are presented much the same way an interstitial is.

.. code-block:: objective-c

    - (void) didLoadAd:(SAAd *)ad {
      // alloc and init a new SAFullscreenVideoAd object
      SAFullscreenVideoAd *fullvideo = [[SAFullscreenVideoAd alloc] init];

      // set actual ad data for
      [fullvideo setAd:ad];

      // set parameters
      [fullvideo setShouldAutomaticallyCloseAtEnd:false];
      [fullvideo setShouldShowCloseButton:true];

      // assuming "self" is a ViewController, present the "fullvideo" object
      [self presentViewController:fullvideo animated:YES completion:^{

        // and once it's presented, play the fullscreen ad
        [fullvideo play];
      }];
    }
