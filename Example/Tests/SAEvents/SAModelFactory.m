//
//  SAModelFactory.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SAModelFactory.h"
#import "SAMocks.h"

@implementation SAModelFactory

+ (SAAd*) createDisplayAd: (NSInteger) placementId {
    SAMedia *media = [[MockMedia alloc] initWithSAVASTAd:nil andMedia:@"file.png"];
    SADetails *details = [[MockDetails alloc] initWithMedia:media];
    SACreative *creative = [[MockCreative alloc] initWithFormat:SA_Image andDetails:details];
    return [[MockAd alloc] initWithPlacementId:placementId andCreative:creative];
}

+ (SAAd*) createVideoAd: (NSInteger) placementId {
    SAVASTAd *savastAd = [[MockVastAd alloc] initWithPlacementId:placementId];
    SAMedia *media = [[MockMedia alloc] initWithSAVASTAd:savastAd andMedia:@""];
    SADetails *details = [[MockDetails alloc] initWithMedia:media];
    SACreative *creative = [[MockCreative alloc] initWithFormat:SA_Video andDetails:details];
    return [[MockAd alloc] initWithPlacementId:placementId andCreative:creative];
}

@end
