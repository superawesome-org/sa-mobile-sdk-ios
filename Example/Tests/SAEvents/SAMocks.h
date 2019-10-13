//
//  SAMocks.h
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SAModelSpace/SAAd.h>
#import <SAModelSpace/SACreative.h>
#import <SAModelSpace/SADetails.h>
#import <SAModelSpace/SAMedia.h>
#import <SAModelSpace/SAVASTAd.h>
#import <SAModelSpace/SAVASTMedia.h>
#import <SAModelSpace/SAVASTEvent.h>

@interface MockVastMedia: SAVASTMedia
@end 

@interface MockVastEvent: SAVASTEvent
- (id) initWithEvent: (NSString*) event
      andPlacementId: (NSInteger) placementId;
@end 

@interface MockVastAd: SAVASTAd
- (id) initWithPlacementId: (NSInteger) placementId;
@end

@interface MockMedia: SAMedia
- (id) initWithSAVASTAd: (SAVASTAd*) savastAd
               andMedia: (NSString*) media;
@end

@interface MockDetails: SADetails
- (id) initWithMedia: (SAMedia*) media;
@end

@interface MockCreative: SACreative
- (id) initWithFormat: (SACreativeFormat) format
           andDetails: (SADetails*) details;
@end

@interface MockAd: SAAd
- (id) initWithPlacementId: (NSInteger) placementId
               andCreative: (SACreative*) creative;
@end
