//
//  ATCompanionView.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 11/19/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import "ATOverlayView.h"

@protocol ATCompanionViewDelegate;

/**
 * Represents one companion ad that you place on one of your views.
 *
 * For each companion ad you want to place in your app create one instance of this class.
 * The view will call the delegate when different events occur in the companion ad's lifecycle.
 *
 * @since 3.4.1
 *
 * @see ATCompanionViewDelegate
 */
@interface ATCompanionView : ATOverlayView

/**
 * The delegate gets notified of different events in the lifecycle of the companion ad. It is not required to be set.
 *
 * @since 3.4.1
 */
@property (nonatomic, weak) id<ATCompanionViewDelegate> delegate;

/**
 * The view controller that is the owner of the companion ad view being shown.
 * The view controller is used to modally present the landing page when the user interacts with the view.
 *
 * @since 3.4.1
 */
@property (nonatomic, weak) UIViewController *viewController;

@end
