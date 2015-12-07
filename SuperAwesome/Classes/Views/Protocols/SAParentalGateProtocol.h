//
//  SAParentalGateProtocol.h
//  Pods
//
//  Created by Gabriel Coman on 23/10/2015.
//
//

#import <UIKit/UIKit.h>

// @brief:
// A custom protocol that defines functions that respond to parental gate
// actions
@protocol SAParentalGateProtocol <NSObject>

// all functions are optional
@optional

// this function is called when a parental gate pop-up "cancel" button is pressed
- (void) parentalGateWasCanceled:(NSInteger)placementId;

// this function is called when a parental gate pop-up "continue" button is
// pressed and the parental gate failed (because the numbers weren't OK)
- (void) parentalGateWasFailed:(NSInteger)placementId;

// this function is called when a parental gate pop-up "continue" button is
// pressed and the parental gate succedded
- (void) parentalGateWasSucceded:(NSInteger)placementId;

@end