//
//  SAProtocols.h
//  Pods
//
//  Created by Gabriel Coman on 14/02/2016.
//
//

#import <Foundation/Foundation.h>

// useful imports
@class SAAd;

// external protocol for ad view objects to communicate w/ user
@protocol SAProtocol <NSObject>

@optional

// all functions are optional here
- (void) SADidLoadAd:(id) sender forPlacementId: (NSInteger) placementId;
- (void) SADidNotLoadAd:(id) sender forPlacementId: (NSInteger) placementId;
- (void) SADidShowAd:(id) sender;
- (void) SADidNotShowAd:(id) sender;
- (void) SADidCloseAd:(id) sender;
- (void) SADidClickAd:(id) sender;

@end