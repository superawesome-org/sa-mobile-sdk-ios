//
//  SAPadlockView2.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import <UIKit/UIKit.h>

// forward declaration for SAAd
@class SAAd;

// @brief:
// The padlock view, that gets called from the padlock button
// most of the things are loaded from SAPadlickView.xib
@interface SAPadlockView : UIView

// custom init function for use inside the iOS SDK
- (id) initWithAd:(SAAd *)ad;

// custom init function for use inside the Unity SDK (for now)
- (id) initWithPlacementId:(NSInteger)placementId
             andCreativeId:(NSInteger)creativeId
             andLineItemId:(NSInteger)lineItemId;

@end
