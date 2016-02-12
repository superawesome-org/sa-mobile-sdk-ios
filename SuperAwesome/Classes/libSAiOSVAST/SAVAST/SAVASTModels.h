//
//  SAVAST Model Space
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/14/2015.
//
//

#import <Foundation/Foundation.h>

//
// @brief: the generic VAST object used here to provide a template so that
// I don't have to declare the - (void) print function each time
@interface SAGenericVAST : NSObject
- (void) print;
@end

//
// @brief: this enum should hold the type of content an ad holds
typedef enum SAAdType {
    Invalid = -1,
    InLine = 0,
    Wrapper = 1
}SAAdType;

//
// @brief: the simplified representation of a VAST ad
// - some details have been contactenated, but all important data is here
@interface SAVASTAd : SAGenericVAST
@property (nonatomic, assign) SAAdType type;
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *sequence;
@property (nonatomic, strong) NSMutableArray *Errors;
@property (nonatomic, strong) NSMutableArray *Impressions;
@property (nonatomic, strong) NSMutableArray *Creatives;
@end

//
// @brief: the impressions class
@interface SAImpression: SAGenericVAST
@property (nonatomic, assign) BOOL isSent;
@property (nonatomic, strong) NSString *URL;
@end

//
// @brief: this enum says what kind of creative it is
// just so that we don't have to check the class always
typedef enum SAVASTCreativeType {
    Linear = 0,
    NonLinear = 1,
    CompanionAds = 2
} SAVASTCreativeType;

//
// @brief: the creative parent class
// three types of creatives will eventually descend from this:
// - Linear
// - NonLinear
// - CompanionAds
@interface SAVASTCreative : SAGenericVAST
@property (nonatomic, assign) SAVASTCreativeType type;
@end

//
// @brief: the linear creative basically displays video media from a
// remote source and contains all tracking and click events that should be
// associated
@interface SALinearCreative : SAVASTCreative
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *sequence;
@property (nonatomic, strong) NSString *Duration;
@property (nonatomic, strong) NSString *ClickThrough;
@property (nonatomic, strong) NSString *playableMediaURL;
@property (nonatomic, strong) NSMutableArray *MediaFiles;
@property (nonatomic, strong) NSMutableArray *TrackingEvents;
@property (nonatomic, strong) NSMutableArray *ClickTracking;
@property (nonatomic, strong) NSMutableArray *CustomClicks;
@end

//
// @brief: the non-linear creative is actually an image / flash that gets
// shown over another movie or game or what not
// @todo: implement this!
@interface SANonLinearCreative : SAVASTCreative
@end

//
// @brief: companion ads are shown together with the non-linear or linear
// creative, in different slots
@interface SACompanionAdsCreative : SAVASTCreative
@end

//
// @brief: the tracking object
@interface SATracking : SAGenericVAST
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *URL;
@end

//
// @brief: media file implementation
@interface SAMediaFile : SAGenericVAST
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *URL;
@end