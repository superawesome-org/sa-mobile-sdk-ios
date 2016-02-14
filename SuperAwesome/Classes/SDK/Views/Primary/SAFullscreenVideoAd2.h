//
//  SAFullscreenVideoAd2.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAViewProtocol.h"
#import "SAAdProtocol.h"
#import "SAParentalGateProtocol.h"
#import "SAVideoAdProtocol.h"

@class SAAd;
@class SAVideoAd2;

@interface SAFullscreenVideoAd2 : UIViewController <SAViewProtocol> {
    SAAd *ad;
    CGRect adviewFrame;
    CGRect buttonFrame;
    BOOL isOKToClose;
    
    SAVideoAd2 *video;
    UIButton *closeBtn;
}

@property id<SAAdProtocol> adDelegate;
@property id<SAParentalGateProtocol> parentalGateDelegate;
@property id<SAVideoAdProtocol> videoDelegate;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;
@property (nonatomic, assign) IBInspectable BOOL shouldAutomaticallyCloseAtEnd;
@property (nonatomic, assign) IBInspectable BOOL shouldShowCloseButton;

@end
