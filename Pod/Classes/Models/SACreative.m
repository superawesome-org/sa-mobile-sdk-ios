//
//  SACreative.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import this model's header
#import "SACreative.h"
#import "SADetails.h"

@implementation SACreative

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super init]) {
        __id = [jsonDictionary safeIntForKey:@"id"];
        _name = [jsonDictionary safeStringForKey:@"name"];
        _cpm = [jsonDictionary safeIntForKey:@"cpm"];
        _format = [jsonDictionary safeStringForKey:@"format"];
        _impressionUrl = [jsonDictionary safeStringForKey:@"impressionUrl"];
        _clickUrl = [jsonDictionary safeStringForKey:@"clickUrl"];
        _live = [jsonDictionary safeBoolForKey:@"live"];
        _approved = [jsonDictionary safeBoolForKey:@"approved"];
        _details = [[SADetails alloc] initWithJsonDictionary:[jsonDictionary objectForKey:@"details"]];
        _creativeFormat = (SACreativeFormat)[jsonDictionary safeIntForKey:@"creativeFormat"];
        _viewableImpressionUrl = [jsonDictionary safeStringForKey:@"viewableImpressionUrl"];
        _trackingUrl = [jsonDictionary safeStringForKey:@"trackingUrl"];
        _parentalGateClickUrl = [jsonDictionary safeStringForKey:@"parentalGateClickUrl"];
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"id": @(__id),
        @"name": nullSafe(_name),
        @"cpm": @(_cpm),
        @"format": nullSafe(_format),
        @"impressionUrl": nullSafe(_impressionUrl),
        @"clickUrl": nullSafe(_clickUrl),
        @"live": @(_live),
        @"approved": @(_approved),
        @"details": nullSafe([_details dictionaryRepresentation]),
        @"creativeFormat": @(_creativeFormat),
        @"viewableImpressionUrl": nullSafe(_viewableImpressionUrl),
        @"trackingUrl": nullSafe(_trackingUrl),
        @"parentalGateClickUrl": nullSafe(_parentalGateClickUrl)
    };
}

@end
