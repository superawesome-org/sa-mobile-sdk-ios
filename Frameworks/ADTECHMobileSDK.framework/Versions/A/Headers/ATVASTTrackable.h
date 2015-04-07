//
//  ATVASTTrackable.h
//  ADTECHMobileSDK
//
//  Created by Balint Dezso on 8/6/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATVASTEnums.h"

@interface ATVASTTrackable : NSObject

@property (nonatomic, readonly) NSMutableArray *trackingEvents;

- (BOOL)shouldTrack:(ATVASTTrackingEvent)event;
- (NSArray*)trackingURLsForEvent:(ATVASTTrackingEvent)event;
- (NSArray *)trackingURLsForProgressEventAtTime:(NSTimeInterval)time
                              withTotalDuration:(NSTimeInterval)totalTime;

@end
