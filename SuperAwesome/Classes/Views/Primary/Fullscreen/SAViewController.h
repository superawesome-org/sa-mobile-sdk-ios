//
//  SAViewController.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 21/10/2015.
//
//

#import <UIKit/UIKit.h>

// forward declarations for SAView
@class SAView;
@class SAAd;

// import SAView Protocol
#import "SAAdProtocol.h"

// import parental gate protocol
#import "SAParentalGateProtocol.h"

// @brief:
// The SAViewController is the fullscreen equivalent to SAView
// It also defines a number of private instance variables, around
// a SAView object
@interface SAViewController : UIViewController {
    // internal SAView object - that must be here to be accessible to
    // descendants
    SAView *adview;
    
    // the close button
    UIButton *closeBtn;
    
    // frames that need to be private ivars because they are used in
    // subclasses
    CGRect adviewFrame;
    CGRect buttonFrame;
}

// delegate of the SA View protocol
@property id<SAAdProtocol> delegate;

// delegate for the SA Parental Gate protocol
@property id<SAParentalGateProtocol> pgdelegate;

// the ad associated with this ad view
@property (nonatomic, retain) SAAd *ad;

// a boolean that determines whether parental gate will be shown or not
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

// an integer which specifies when an ad should be relaoded
@property (nonatomic, assign) IBInspectable NSInteger refreshPeriod;

// play instant function
- (void) play;

// close the fullscreen ad
- (void) close;

@end
