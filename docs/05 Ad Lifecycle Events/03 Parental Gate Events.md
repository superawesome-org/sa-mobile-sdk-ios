Finally, you can implement the `SAParentalGateProtocol` to capture parental gate events:

```
@interface MyViewController () <SAParentalGateprotocol> 

	// this function is called when a parental gate pop-up "cancel" button is pressed
	- (void) parentalGateWasCanceled:(NSInteger)placementId {

	}

	// this function is called when a parental gate pop-up "continue" button is
	// pressed and the parental gate failed (because the numbers weren't OK)
	- (void) parentalGateWasFailed:(NSInteger)placementId {

	}

	// this function is called when a parental gate pop-up "continue" button is
	// pressed and the parental gate succedded
	- (void) parentalGateWasSucceded:(NSInteger)placementId {
		
	}

```

And just as before, any ads in your app must set their `parentalGateDelegate` object to `MyViewController`, as the class that implements the SAParentalGateProtocol interface.

```
video = [[SAVideoAd alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
[video setParentalGateDelegate: self]; // where "self" is the view controller

```