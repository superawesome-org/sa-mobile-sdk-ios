//
//  SAVideoAd2.h
//  Pods
//
//  Created by Gabriel Coman on 22/08/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAProtocols.h"
#import "SAVideoPlayer.h"

// forward declarations
@class SAParentalGate;
@class SAAd;

@interface SAVideoAd : UIViewController <SAViewProtocol>

@property (nonatomic, weak) id<SAProtocol> delegate;

@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;
@property (nonatomic, assign) BOOL shouldShowCloseButton;
@property (nonatomic, assign) BOOL shouldLockOrientation;
@property (nonatomic, assign) BOOL shouldShowSmallClickButton;
@property (nonatomic, assign) NSUInteger lockOrientation;

// functions
- (void) pause;
- (void) resume;

@end
