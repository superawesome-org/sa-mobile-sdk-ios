//
//  SAAd.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import this model's header
#import "SAAd.h"

#import "SACreative.h"
#import "SADetails.h"
#import "SAData.h"

@implementation SAAd

- (id) init {
    if (self = [super init]){
    
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super init]) {
        
        _error = [jsonDictionary safeIntForKey:@"error"];
        _app = [jsonDictionary safeIntForKey:@"app"];
        _placementId = [jsonDictionary safeIntForKey:@"placementId"];
        _lineItemId = [jsonDictionary safeIntForKey:@"lineItemId"];
        _campaignId = [jsonDictionary safeIntForKey:@"campaignId"];
        _test = [jsonDictionary safeBoolForKey:@"test"];
        _isFallback = [jsonDictionary safeBoolForKey:@"isFallback"];
        _isFill = [jsonDictionary safeBoolForKey:@"isFill"];
        _isHouse = [jsonDictionary safeBoolForKey:@"isHouse"];
        _creative = [[SACreative alloc] initWithJsonDictionary:[jsonDictionary objectForKey:@"creative"]];
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"error": @(_error),
        @"app": @(_app),
        @"placementId": @(_placementId),
        @"lineItemId": @(_lineItemId),
        @"campaignId": @(_campaignId),
        @"test": @(_test),
        @"isFallback": @(_isFallback),
        @"isFill": @(_isFill),
        @"isHouse": @(_isHouse),
        @"creative": nullSafe([_creative dictionaryRepresentation])
    };
}

- (BOOL) isValid {
    
    if (_creative == NULL) return false;
    if (_creative.creativeFormat == invalid) return false;
    if (_creative.details == NULL) return false;
    
    switch (_creative.creativeFormat) {
        case image: {
            if (_creative.details.image == NULL) return false;
            break;
        }
        case video:{
            if (_creative.details.vast == NULL) return false;
            break;
        }
        case invalid:{
            return false;
            break;
        }
        case tag:{
            if (_creative.details.tag == NULL) return false;
            break;
        }
        case rich:{
            if (_creative.details.url == NULL) return false;
            break;
        }
    }
    
    return true;
}

@end
