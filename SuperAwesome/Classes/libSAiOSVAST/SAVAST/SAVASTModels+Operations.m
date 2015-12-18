//
//  SAVASTModels+Operations.m
//  Pods
//
//  Created by Gabriel Coman on 17/12/2015.
//
//

#import "SAVASTModels+Operations.h"
#import "libSAiOSNetwork.h"

@implementation SAVASTAd (Operations)

- (void) sumAd:(SAVASTAd *)ad {
    
    // old ad gets _id of new ad (does not really affect anything)
    self._id = ad._id;
    // and the sequence is overriden (again, does not affect anything)
    self.sequence = ad.sequence;
    
    // summing errors
    [self.Errors addObjectsFromArray:ad.Errors];
    // suming impressions
    [self.Impressions addObjectsFromArray:ad.Impressions];
    // and creatives (and for now we assume we only have linear ones)
    // don't sum-up creatives now
    for (SALinearCreative *creative in self.Creatives) {
        for (SALinearCreative *creative2 in ad.Creatives) {
            [creative sumCreative:creative2];
        }
    }
}

@end

@implementation SAVASTCreative (Operations)

- (void) sumCreative:(SAVASTCreative *)creative {
    // do nothing here
}

@end

@implementation SALinearCreative (Operations)

- (void) sumCreative:(SALinearCreative *)creative {
    
    // perform a "Sum" operation
    // first override some unimportant variables
    self._id = creative._id;
    self.sequence = creative.sequence;
    self.Duration = creative.Duration;
    
    if ([SAURLUtils isValidURL:self.ClickThrough]) {
        self.ClickThrough = self.ClickThrough;
    }
    if ([SAURLUtils isValidURL:creative.ClickThrough]) {
        self.ClickThrough = creative.ClickThrough;
    }
    
    // then concatenate arrays (this is what's important)
    [self.MediaFiles addObjectsFromArray:creative.MediaFiles];
    [self.TrackingEvents addObjectsFromArray:creative.TrackingEvents];
    [self.ClickTracking addObjectsFromArray:creative.ClickTracking];
    [self.CustomClicks addObjectsFromArray:creative.CustomClicks];
}

@end