/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SABannerAd.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAResponse.h>)
#import <SAModelSpace/SAResponse.h>
#else
#import "SAResponse.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SACreative.h>)
#import <SAModelSpace/SACreative.h>
#else
#import "SACreative.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SADetails.h>)
#import <SAModelSpace/SADetails.h>
#else
#import "SADetails.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAMedia.h>)
#import <SAModelSpace/SAMedia.h>
#else
#import "SAMedia.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAImageUtils.h>)
#import <SAUtils/SAImageUtils.h>
#else
#import "SAImageUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAEvents/SAEvents.h>)
#import <SAEvents/SAEvents.h>
#else
#import "SAEvents.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAWebPlayer/SAWebPlayer.h>)
#import <SAWebPlayer/SAWebPlayer.h>
#else
#import "SAWebPlayer.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAAdLoader/SALoader.h>)
#import <SAAdLoader/SALoader.h>
#else
#import "SALoader.h"
#endif
#endif

// local imports
#import "SuperAwesome.h"
#import "SAParentalGate.h"

@interface SABannerAd () <SAParentalGateProtocol>

// main state vars
@property (nonatomic, strong) sacallback         callback;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

// events
@property (nonatomic, strong) SASession          *session;
@property (nonatomic, strong) SAEvents           *events;

// current ad
@property (nonatomic, strong) SAAd               *ad;

// subviews
@property (nonatomic, strong) SAWebPlayer        *webplayer;
@property (nonatomic, strong) SAParentalGate     *gate;
@property (nonatomic, strong) UIButton           *padlock;

// aux state vats
@property (nonatomic, assign) BOOL               canPlay;
@property (nonatomic, assign) BOOL               firstPlay;

@end

@implementation SABannerAd

/**
 * Custom init for code-based initialization
 *
 * @return a new instance of SABannerAd
 */
- (id) init {
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

/**
 * Custom init for XIB base initialization
 *
 * @return a new instance of SABannerAd
 */
- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

/**
 * Custom init for code-based initialization with a frame
 *
 * @return a new instance of SABannerAd
 */
- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

/**
 * Method that actually inits the banner, creates new obejcts and sets the
 * default values.
 */
- (void) initialize {
    // set "canPlay" to true when building the first banner
    _canPlay = true;
    _firstPlay = true;
    
    // init the events and session obkects
    _events = [[SAEvents alloc] init];
    _session = [[SASession alloc] init];
    
    // set a default callback, so that it's never null and I don't have to
    // do a null check everytime I want to call it
    _callback = ^(NSInteger placement, SAEvent event) {};
    
    // set default banner parameters
    _isParentalGateEnabled = SA_DEFAULT_PARENTALGATE;
    [self setTestMode:SA_DEFAULT_TESTMODE];
    [self setConfiguration:SA_DEFAULT_CONFIGURATION];
    [self setColor:SA_DEFAULT_BGCOLOR];
}

- (void) load:(NSInteger)placementId {
    
    // first close any existing ad
    if (!_firstPlay) {
        [self close];
    }
    
    // reset playability
    _canPlay = false;
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // change session
    [_session setVersion:[[SuperAwesome getInstance] getSdkVersion]];
    
    // load ad
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:placementId withSession:_session andResult:^(SAResponse *response) {

        // set can play
        weakSelf.canPlay = [response isValid];

        // assign new ad
        weakSelf.ad = [response isValid] ? [response.ads objectAtIndex:0] : nil;
        
        // call the callback
        weakSelf.callback (placementId, [response isValid] ? adLoaded : adFailedToLoad);
    }];
}

- (void) play {
    
    if (_ad && _ad.creative.format != SA_Video && _canPlay) {
        
        // reset play-ability
        _canPlay = false;
        _firstPlay = false;
        
        // get a weak self reference
        __weak typeof (self) weakSelf = self;
        
        // start events
        [_events setAd:_ad];
        
        // add the sawebview
        _webplayer = [[SAWebPlayer alloc] initWithContentSize:CGSizeMake(_ad.creative.details.width, _ad.creative.details.height)
                                               andParentFrame:self.frame];
        
        // moat tracking
        NSString *moatString = [_events moatEventForWebPlayer:[_webplayer getWebView]];
        NSLog(@"MOAT String is %@", moatString);
        
        // form the full HTML string and play it!
        NSString *fullHTMLToLoad = [_ad.creative.details.media.html stringByReplacingOccurrencesOfString:@"_MOAT_" withString:moatString];
        
        // add callbacks for web player events
        [_webplayer setEventHandler:^(SAWebPlayerEvent event) {
            switch (event) {
                case saWeb_Start: {
                    // send callback
                    weakSelf.callback(weakSelf.ad.placementId, adShown);
                    
                    // if the banner has a separate impression URL, send that as well for 3rd party tracking
                    // [weakSelf.events sendAllEventsForKey:@"impression"];
                    // [weakSelf.events sendAllEventsForKey:@"sa_impr"];
                    
                    // send viewable impression
                    [weakSelf.events sendViewableImpressionForDisplay:weakSelf];
                    
                    break;
                }
                case saWeb_Error: {
                    // send callback
                    weakSelf.callback(weakSelf.ad.placementId, adFailedToShow);
                    break;
                }
            }
        }];
        
        // add callbacks for clicks
        [_webplayer setClickHandler:^(NSURL *url) {
            
            // only call the next part (either pg or click) if the click
            // url is valid, else do nothong
            if (url && [url absoluteString]) {
                if (weakSelf.isParentalGateEnabled) {
                    weakSelf.gate = [[SAParentalGate alloc] initWithPosition:0 andDestination:[url absoluteString]];
                    weakSelf.gate.delegate = weakSelf;
                    [weakSelf.gate show];
                } else {
                    [weakSelf click: [url absoluteString]];
                }
            }
        
        }];
        
        // add the webplayer as a subview
        [self addSubview:_webplayer];
        
        // add the padlock
        _padlock = [[UIButton alloc] initWithFrame:CGRectZero];
        [_padlock setImage:[SAImageUtils padlockImage] forState:UIControlStateNormal];
        [_padlock addTarget:self action:@selector(padlockAction) forControlEvents:UIControlEventTouchUpInside];
        if ([self shouldShowPadlock]) {
            [_webplayer addSubview:_padlock];
        }
        
        // resize
        [self resize:self.frame];
        
        // finally play!
        [_webplayer loadHTML:fullHTMLToLoad];
        
        // add a notification of sorts
        [[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification"
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:
         ^(NSNotification * note) {
             
             // resize
             [weakSelf resize:weakSelf.frame];
         }];
        
    } else {
        // failure callback
        _callback (0, adFailedToShow);
    }
}

/**
 * Internal setter for the "ad" object. This is very important because 
 * based on the loaded ad, that's what's going to be displayed.
 *
 * @param ad a new, valid SAAd object
 */
- (void) setAd:(SAAd*) ad {
    _ad = ad;
}

/**
 * Internal method that nulls the ad
 */
- (void) nullAd {
    _ad = NULL;
}

- (BOOL) hasAdAvailable {
    return _ad != NULL;
}

/**
 * Method that returns, based on several conditions, if the ad should display
 * the "safeAd" logo or not.
 *
 * @return true or false
 */
- (BOOL) shouldShowPadlock {
    if (_ad.creative.format == SA_Tag) return false;
    if (_ad.isFallback) return false;
    if (_ad.isHouse && !_ad.safeAdApproved) return false;
    return true;
}

- (void) close {
    // callback
    _callback (_ad.placementId, adClosed);
    
    // close events
    [_events close];
    
    // remove all stuffs
    [_webplayer removeFromSuperview];
    _webplayer = nil;
    [_padlock removeFromSuperview];
    _padlock = nil;
    _gate = nil;
    [self nullAd];
    
    // remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification"
                                                  object:nil];
}

/**
 * Method that is called when a user clicks / taps on an ad
 */
- (void) click: (NSString*) destination {
    
    NSLog(@"[AA :: INFO] Trying to go to: %@", destination);
    
    // callback
    _callback (_ad.placementId, adClicked);
    
    // send external click counter events
    [_events sendAllEventsForKey:@"clk_counter"];
    
    // send the install e vent (if this is a CPI campaign)
    [_events sendAllEventsForKey:@"install"];
    
    // events
    if ([destination rangeOfString:[_session getBaseUrl]].location == NSNotFound) {
        [_events sendAllEventsForKey:@"sa_tracking"];
    }
    
    // open URL
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:destination]];
}

- (void) resize:(CGRect)toframe {
    
    // new frame
    self.frame = toframe;
    
    // rearrange the webview
    [_webplayer updateParentFrame:toframe];
    
    // rearrange the padlock
    _padlock.frame = CGRectMake(0, 0, 67, 25);
    [self bringSubviewToFront:_padlock];
}

/**
 * Method part of SAParentalGateProtocol called when the gate is opened
 *
 * @param position int representing the ad position in the ads response array
 */
- (void) parentalGateOpen:(NSInteger)position {
    // send all events for parental gate open
    [_events sendAllEventsForKey:@"pg_open"];
}

/**
 * Method part of SAParentalGateProtocol called when the gate is failed
 *
 * @param position int representing the ad position in the ads response array
 */
- (void) parentalGateFailure:(NSInteger)position {
    // send all events for parental gate failure
    [_events sendAllEventsForKey:@"pg_fail"];
}

/**
 * Method part of SAParentalGateProtocol called when the gate is successful
 *
 * @param position    int representing the ad position in the ads response array
 * @param destination URL destination
 */
- (void) parentalGateSuccess:(NSInteger)position andDestination:(NSString *)destination {
    // send success events
    [_events sendAllEventsForKey:@"pg_success"];
    
    // go to click
    [self click:destination];
}

/**
 * Method part of SAParentalGateProtocol called when the gate is closed
 *
 * @param position int representing the ad position in the ads response array
 */
- (void) parentalGateCancel:(NSInteger)position {
    // send all events for parental gate close
    [_events sendAllEventsForKey:@"pg_close"];
}

/**
 * Method called when the user clicks on a padlock
 */
- (void) padlockAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ads.superawesome.tv/v2/safead"]];
}

- (void) setCallback:(sacallback)callback {
    _callback = callback ? callback : _callback;
}

- (void) enableParentalGate {
    [self setParentalGate:true];
}

- (void) disableParentalGate {
    [self setParentalGate:false];
}

- (void) enableTestMode {
    [self setTestMode:true];
}

- (void) disableTestMode {
    [self setTestMode:false];
}

- (void) setConfigurationProduction {
    [self setConfiguration:PRODUCTION];
}

- (void) setConfigurationStaging {
    [self setConfiguration:STAGING];
}

- (void) setColorTransparent {
    [self setColor:true];
}

- (void) setColorGray {
    [self setColor:false];
}

- (void) setTestMode: (BOOL) value {
    [_session setTestMode:value];
}

- (void) setParentalGate: (BOOL) value {
    _isParentalGateEnabled = value;
}

- (void) setConfiguration: (NSInteger) value {
    [_session setConfiguration:value];
}

- (void) setColor: (BOOL) value {
    if (value) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1];
    }
}


@end
