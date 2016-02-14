//
//  SAFullscreenVideoAd2.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAProtocols.h"

@class SAAd;
@class SAVideoAd;

@interface SAFullscreenVideoAd : UIViewController <SAViewProtocol> {
    SAAd *ad;
    CGRect adviewFrame;
    CGRect buttonFrame;
    BOOL isOKToClose;
    
    SAVideoAd *video;
    UIButton *closeBtn;
}

@property id<SAAdProtocol> adDelegate;
@property id<SAParentalGateProtocol> parentalGateDelegate;
@property id<SAVideoAdProtocol> videoDelegate;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;
@property (nonatomic, assign) IBInspectable BOOL shouldAutomaticallyCloseAtEnd;
@property (nonatomic, assign) IBInspectable BOOL shouldShowCloseButton;

@end
