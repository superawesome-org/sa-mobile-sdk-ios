Display Ads
===========

In the next three sections we'll see how to display banners, interstitials and fullscreen video ads.

We'll suppose that we already successfully loaded and saved ad data for three placements,
as in the last example of the previous chapter. We'll thus have:

============    ==================
Placement Id    Saved in Ad object
============    ==================
30471           bannerAdData
30473           interstitialAdData
30479           videoAdData
============    ==================

We'll also want to show each ad at the press of a button.

Banner ads
^^^^^^^^^^

To following code snippet shows you how to add a **SABannerAd** object to your view controller.

.. code-block:: objective-c

    @implementation MyViewController
      // rest of your implementation ...

      - (IBAction) showBanner {
        CGRect top = CGRectMake(0, 0, 320, 50);
        SABannerAd *banner = [[SABannerAd alloc] initWithFrame:top];
        [banner setAd:bannerAdData];

        [self.view addSubview: banner];
        [banner play];
      }

    @end

Notice that SABannerAd is a subclass of the generic SAView class in iOS. Thus it needs to be initialized using
**initWithFrame:** and needs to be added to the view hierarchy.

The two actually new functions here are **setAd:** and **play**.

* **setAd:** takes a SAAd object as parameter, in this case bannerAdData. It tells the banner what ad data to try to display.
* **play** actually starts the display process on screen.

Interstitial ads
^^^^^^^^^^^^^^^^

Interstitial ads have a similar method of displaying. They are represented by objects of type **SAInterstitialAd**.

.. code-block:: objective-c

    @implementation MyViewController
      // rest of your implementation ...

      - (IBAction) showInterstitial {
        SAInterstitialAd *interstitial = [[SAInterstitialAd alloc] init];
        [interstitial setAd:interstitialAdData];

        [self presentViewController:interstitial animated:YES completion:^{
          [interstitial play];
        }];
    }

    @end

Again, notice the presence of setAd: and play - they perform the same role as for banner ads.

The differences here is that the SAInterstitialAd class subclasses UIViewController, so it must be presented on screen as such.

Interstitials can be closed by calling the **close** function.

Fullscreen video ads
^^^^^^^^^^^^^^^^^^^^

Finally, fullscreen video ads are represented by **SAFullscreenVideoAd**.

.. code-block:: objective-c

    @implementation MyViewController
    // rest of your implementation ...

      - (IBAction) showVideo {
        SAFullscreenVideoAd *video = [[SAFullscreenVideoAd alloc] init];
        [video setAd:videoAdData];

        [self presentViewController:video animated:YES completion:^{
          [video play];
        }];
      }

    @end

SAFullscreenVideoAd is also a subclasses of UIViewController, and implements the setAd: and play methods.

However, a video ad can have two additional parameters set:

.. code-block:: objective-c

    @implementation MyViewController
    // rest of your implementation ...

      - (IBAction) showVideo {
        SAFullscreenVideoAd *video = [[SAFullscreenVideoAd alloc] init];
        [video setAd:videoAdData];
        [video setShouldAutomaticallyCloseAtEnd:NO];
        [video setShouldShowCloseButton:YES];

        // rest of the function ...
      }

    @end

Fullscreen video ads can be close by calling the **close** function.
