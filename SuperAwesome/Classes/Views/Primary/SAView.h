//
//  SAView.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

#import <UIKit/UIKit.h>

// the view protocol
#import "SAAdProtocol.h"

// and the parental gate protocol
#import "SAParentalGateProtocol.h"

// forward declarations of different classes that are needed for a SAView
@class SAAd;
@class SAParentalGate;
@class SAPadlock;

// Interface declaration of SAView with some private instance variables
@interface SAView : UIView {
    
    // private subviews - but that will be visible to descendants
    SAParentalGate *gate;
    SAPadlock *pad;

}

// delegate of the SA View protocol
@property id<SAAdProtocol> delegate;
@property id<SAParentalGateProtocol> pgdelegate;

// the ad associated with this ad view
@property (nonatomic, retain) SAAd *ad;

// a boolean that determines whether parental gate will be shown or not
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

// an integer which specifies when an ad should be relaoded
@property (nonatomic, assign) IBInspectable NSInteger refreshPeriod;

// play instant function
- (void) play;

// gotoURL
- (void) advanceToClick;

@end
