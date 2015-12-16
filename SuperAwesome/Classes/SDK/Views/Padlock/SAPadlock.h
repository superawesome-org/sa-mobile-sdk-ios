//
//  SAPadlockView2.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import <Foundation/Foundation.h>

// forward declarations
@class SAView;

// @brief:
// The padlock class, that handles everything regarding to the padlick
@interface SAPadlock : NSObject

// custom init functions
- (id) initWithWeakRefToView:(SAView*)weakRef;

// function to add padlock button to the weakRef view
- (void) addPadlockButtonToSubview:(UIView*)view;

// and remove the padlock
- (void) removePadlockButton;

@end
