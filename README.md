SuperAwesome Mobile SDK for iOS
===============================

Setting Up SAMobileSDK
-----------------------

We use [CocoaPods](http://cocoapods.org) in order to make installing and updating our SDK super easy. CocoaPods manages library dependencies for your Xcode projects.

### Installing CocoaPods
If you have not got CocoaPods installed on your machine you can install it by using the following commands:
```
sudo gem install cocoapods
pod init # run in your project's directory
```
### Getting the SDK
The dependencies for your projects are specified in a single text file called a Podfile. CocoaPods will resolve dependencies between libraries, fetch the resulting source code, then link it together in an Xcode workspace to build your project.
To download our SDK add the following line to your Podfile:
```
pod 'SAMobileSDK', :git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git'
```
After the pod source has been added, update your project's dependecies by running the following command in the terminal:
```
pod update
```
Don't forget to use the .xcworkspace file to open your project in Xcode, instead of the .xcproj file, from here on out.

We recommend using the stable releases of our SDK, but if you want to try out the developer preview versions modify your Podfile as follows:
```
pod 'SAMobileSDK', :git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git', :branch => 'dev'
```

Integrating the SuperAwesome Platform
-------------------------------------

### User Authentication

The SuperAwesome SDK for iOS provides various login experiences that your app can use to authenticate someone. This document includes all the information you need to know in order to implement SuperAwesome login in your iOS app.

![](images/sign_in.png?raw=true "Signing In With SuperAwesome")

Sessions and permissions are stored in access tokens, which are cached automatically by the SDK so they are available when a logged in user returns to your app. The SDK provides prebuilt UI components that you can use to log people in and out of your app.

In order to use the SDK you need to import the header file.
```	
#import <SuperAwesomeSDK/SuperAwesomeSDK.h>
```
To show the SuperAwesome login page instantiate SALoginViewController.
```
SALoginViewController *vc = [[SALoginViewController alloc] init];
vc.delegate = self;
[self presentViewController:vc animated:YES completion:nil];
```
By implementing the SALoginViewControllerDelegate protocol you can get notified about the result of the authentication procedure.
```
@protocol SALoginViewControllerDelegate <UINavigationControllerDelegate>
@optional
- (void)loginViewController:(SALoginViewController *)loginVC didSucceedWithToken:(NSString *)token;
- (void)loginViewController:(SALoginViewController *)loginVC didFailWithError:(NSString *)error;
@end
```

### Awarding SuperAwesome Points
TBD

Integrating SuperAwesome Advertising
------------------------------------
###Displaying a Banner Ad Using Interface Builder

Add the banner to the xib (or storyboard) file: Go to your xib file and add a UIView element to the view. In the Identity Inspector pane set the class of the view to SABannerView.

![](images/custom_class.png?raw=true "Setting custom class to UIView")

In the Size Inspector pane set the size of the banner. The following sizes are supported:
  * 320x50
  * 300x50
  * 728x90 (tablet)
 
####Implementing SABannerViewDelegate
If you want to be notified of various events in the banner lifecycle, you can set its delegate to an object instance that implements the SABannerViewDelegate protocol. For example, you could add this protocol to your view controllers interface definition and optionally implement some of the methods defined in the protocol. At least shouldSuspendForAd and shoudResumeForAd method should be implemented so that you know when the host app should be suspended and resumed. (e.g. the user is playing a game then sees an attractive ad, it clicks on it and the ad expands covering the whole UI; the game going on in the host application should be suspended while the banner is expanded).

SABannerViewDelegate provides the following methods:
```
- (void)shouldSuspendForAd:(SABannerView *)view;
- (void)shouldResumeForAd:(SABannerView *)view;
- (void)willLeaveApplicationForAd:(SABannerView *)view;
```

####Setting the visibility flag of the banner
One last thing you need to do is keep the banners visibility flag up to date. This is im- portant so that the banner knows when to work for you and refresh the ads and when to pause. Failing to set the visibility flag when needed, you might have your users miss important ads for their interests.

You should keep the visibility flag on YES when the banner is displayed and viewable by the user, but when the banner gets off-screen (maybe through the user scrolling content and by navigating to another screen), you should set the visibility flag to NO. A good practice is to set the visibility flag is on viewDidDisappear and viewDidAppear methods.

```
- (void)viewDidDisappear:(BOOL)animated
{
 [super viewDidDisappear:animated];
 banner.visible = NO;
 }
 
- (void)viewDidAppear:(BOOL)animated
{
 banner.visible = YES;
 [super viewDidAppear:animated];
}
```

###Displaying an Interstitial Ad
```
@interface ViewController ()
@property (nonatomic,strong) SAInterstitialView *interstitial;
@end

...

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.interstitial = [[SAInterstitialView alloc] initWithViewController:self];
}

- (IBAction)presentInterstitionalAd:(id)sender
{
    [self.interstitial present];
}
```
