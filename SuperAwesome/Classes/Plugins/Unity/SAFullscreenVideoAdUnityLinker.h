//
//  SAUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 13/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SAAd;

// callback for generic success with data
typedef void (^adEvent)(NSString *unityAd, NSInteger placementId);

@interface SAFullscreenVideoAdUnityLinker : NSObject

- (void) startWithPlacementId:(NSInteger)placementId
                    andAdJson:(NSString*)adJson
                 andUnityName:(NSString*)unityAd
           andHasParentalGate:(BOOL)isParentalGateEnabled
            andHasCloseButton:(BOOL)shouldShowCloseButton
               andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd;

@property (nonatomic, assign) adEvent adWasShownBlock;
@property (nonatomic, assign) adEvent adFailedToShowBlock;
@property (nonatomic, assign) adEvent adWasClosedBlock;
@property (nonatomic, assign) adEvent adWasClickedBlock;
@property (nonatomic, assign) adEvent adHasIncorrectPlacementBlock;

@property (nonatomic, assign) adEvent parentalGateWasCanceledBlock;
@property (nonatomic, assign) adEvent parentalGateWasFailedBlock;
@property (nonatomic, assign) adEvent parentalGateWasSuccededBlock;

@property (nonatomic, assign) adEvent adStartedBlock;
@property (nonatomic, assign) adEvent videoStartedBlock;
@property (nonatomic, assign) adEvent videoReachedFirstQuartileBlock;
@property (nonatomic, assign) adEvent videoReachedMidpointBlock;
@property (nonatomic, assign) adEvent videoReachedThirdQuartileBlock;
@property (nonatomic, assign) adEvent videoEndedBlock;
@property (nonatomic, assign) adEvent adEndedBlock;
@property (nonatomic, assign) adEvent allAdsEndedBlock;

@end
