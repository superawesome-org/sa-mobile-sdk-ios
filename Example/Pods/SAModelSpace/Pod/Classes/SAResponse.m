//
//  SAResponse.m
//  Pods
//
//  Created by Gabriel Coman on 27/09/2016.
//
//

#import "SAResponse.h"

#import "SAAd.h"

@implementation SAResponse

- (id) init {
    if (self = [super init]){
        _ads = [@[] mutableCopy];
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        _placementId = [[jsonDictionary objectForKey:@"placementId"] integerValue];
        _status = [[jsonDictionary objectForKey:@"status"] integerValue];
        _format = (SACreativeFormat) [[jsonDictionary objectForKey:@"format"] integerValue];
        _ads = [[[NSArray alloc] initWithJsonArray:[jsonDictionary safeObjectForKey:@"ads"] andIterator:^id(id item) {
            return [[SAAd alloc] initWithJsonDictionary:(NSDictionary*)item];
        }] mutableCopy];
    }
    
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
             @"placementId": @(_placementId),
             @"status": @(_status),
             @"format": @(_format),
             @"ads": nullSafe([_ads dictionaryRepresentation])
             };
}

- (BOOL) isValid {
    return [_ads count] > 0;
}

@end
