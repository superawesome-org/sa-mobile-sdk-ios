//
//  UIAlertController+Window.h
//  libSAiOSUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 24/09/2015.
//
//

#import <UIKit/UIKit.h>

//
// @brief: A category overy UIAlertViewController that makes it
// popup on top of everything else
@interface UIAlertController (Window)

//
// @brief: override of the classic show function
- (void)show;

//
// @brief: override of the classic show (animated) function
- (void)show:(BOOL)animated;

@end