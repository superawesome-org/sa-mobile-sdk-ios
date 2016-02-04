Callbacks
=========

Using the same delegate pattern all ads can serve additional events than can be caught and acted upon.

Standard ad callbacks
^^^^^^^^^^^^^^^^^^^^^

To catch standard ad callbacks, your **ViewController** or **View** class must
also implement the **SAAdProtocol**:

.. code-block:: objective-c

    // in this example just add
    // the new <SAAdProtocol> to your view controller
    @interface MyViewController () <SALoaderProtocl, SAAdProtocol> {
      // rest of your implementation
    }

This protocol defines a series of optional functions you can implement and catch events with:

.. code-block:: objective-c

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

Finally, to complete the code, all ads must assign their **adDelegate** object to **MyViewController**.
This means that when an ad launches an **adWasShown** or **adWasClosed** event,
the controller will respond with the functions implemented above, similar to how
**UITableViewDelegate** works.

.. code-block:: objective-c

    banner = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    // where "self" is the view controller
    [banner setAdDelegate: self];


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
