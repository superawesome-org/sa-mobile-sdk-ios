//
//  SACreative.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import <Foundation/Foundation.h>

// creative format typedef
typedef enum SACreativeFormat {
    invalid = -1,
    image = 0,
    video = 1,
    rich = 2,
    tag = 3
}SACreativeFormat;

// forward declarations
@class SADetails;

// @brief:
// The creative contains essential ad information like format, click url
// and such
@interface SACreative : NSObject

// the creative ID is a unique ID associated by the server with this Ad
@property (nonatomic, assign) NSInteger creativeId;

// name of the creative - set by the user in the dashboard
@property (nonatomic, strong) NSString *name;

// agreed upon CPM; not really a useful field
@property (nonatomic, assign) NSInteger cpm;

// the creative format defines the type of ad (image, video, rich media, tag, etc)
// and is an enum defined in SACreativeFormat.h
@property (nonatomic, strong) NSString *baseFormat;
@property (nonatomic, assign) SACreativeFormat format;

// the impression URL; not really useful because it's used server-side
@property (nonatomic, strong) NSString *impressionURL;

// the viewable impression URL; used by the SDK to track a viewable impression
@property (nonatomic, strong) NSString *viewableImpressionURL;

// the click URL - taken from the ad server; it's the direct target to
// which the ad points, if it exists
@property (nonatomic, strong) NSString *clickURL;

// the tracking URL
@property (nonatomic, strong) NSString *trackingURL;

// the Parental gate event url
@property (nonatomic, strong) NSString *parentalGateClickURL;

// must be always true for real ads
@property (nonatomic, assign) BOOL approved;

// pointer to a SADetails object containing even more creative information
@property (nonatomic, strong) SADetails *details;

// aux print func
- (void) print;

@end
