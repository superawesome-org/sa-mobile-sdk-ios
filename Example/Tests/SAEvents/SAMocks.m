//
//  SAMocks.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import "SAMocks.h"

@implementation MockVastMedia

- (id) init {
    
    if (self = [super init]) {
        self.type = @"mp4";
        self.url = @"http://api.com/resources/video.mp4";
        self.bitrate = 1000;
        self.width = 640;
        self.height = 320;
    }
    
    return self;
}

@end

@implementation MockVastEvent

- (id) initWithEvent: (NSString*) event
      andPlacementId: (NSInteger) placementId {
    
    if (self = [super init]) {
        self.event = event;
        self.URL = [NSString stringWithFormat:@"http://localhost:64000/vast/event/%@?placement=%ld",
                    event,
                    (unsigned long) placementId];
    }
    
    return self;
}

@end

@implementation MockVastAd

- (id) initWithPlacementId:(NSInteger)placementId {
    
    if (self = [super init]) {
        self.redirect = nil;
        self.type = SA_InLine_VAST;
        self.url = @"http://some/url";
        self.media = [@[[[MockVastMedia alloc] init]] mutableCopy];
        self.events = [@[
                         [[MockVastEvent alloc] initWithEvent:@"vast_impression" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_click_through" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_creativeView" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_start" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_firstQuartile" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_midpoint" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_thirdQuartile" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_complete" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_click_tracking" andPlacementId:placementId],
                         [[MockVastEvent alloc] initWithEvent:@"vast_error" andPlacementId:placementId]
                         ] mutableCopy];
    }
    
    return self;
}

@end

@implementation MockMedia

- (id) initWithSAVASTAd:(SAVASTAd *)savastAd
               andMedia:(NSString *)media {
    
    if (self = [super init]) {
        
        self.html = @"<some></some>";
        self.path = [NSString stringWithFormat:@"file://local/file/resource/%@", media];
        self.url = [NSString stringWithFormat:@"http://localhost:64000/resource/%@", media];
        self.type = @"mp4";
        self.isDownloaded = TRUE;
        self.vastAd = savastAd;
    }
    
    return self;
}

@end

@implementation MockDetails

- (id) initWithMedia:(SAMedia *)media {
    
    if (self = [super init]) {
        
        self.width = 320;
        self.height = 50;
        self.name = @"details";
        self.format = @"image";
        self.bitrate = 0;
        self.duration = 0;
        self.vast = 0;
        self.image = @"some-image";
        self.video = @"some-image";
        self.tag = nil;
        self.zip = nil;
        self.url = nil;
        self.cdn = nil;
        self.base = nil;
        self.vast = nil;
        self.media = media;
    }
    
    return self;
}

@end

@implementation MockCreative

- (id) initWithFormat:(SACreativeFormat)format
           andDetails:(SADetails *)details {
    
    if (self = [super init]) {
        
        self._id = 5001;
        self.name = @"ad-name";
        self.cpm = 3;
        self.format = format;
        self.live = true;
        self.approved = true;
        self.bumper = false;
        self.payload = @"";
        self.clickUrl = nil;
        self.clickCounterUrl = nil;
        self.impressionUrl = nil;
        self.osTarget = [@[] mutableCopy];
        self.bundle = @"com.test.myapp";
        self.details = details;
    }
    
    return self;
}

@end

@implementation MockAd

- (id) initWithPlacementId:(NSInteger)placementId
               andCreative:(SACreative *)creative {
    
    if (self = [super init]) {
        
        self.error = 0;
        self.advertiserId = 1001;
        self.publisherId = 501;
        self.appId = 10;
        self.lineItemId = 2001;
        self.campaignId = 3001;
        self.placementId = placementId;
        self.moat = 0.2;
        self.isTest = false;
        self.isFallback = false;
        self.isFill = false;
        self.isHouse = false;
        self.isSafeAdApproved = true;
        self.isPadlockVisible = true;
        self.device = @"phone";
        self.loadTime = 0;
        self.creative = creative;
    }
    
    return self;
}

@end
