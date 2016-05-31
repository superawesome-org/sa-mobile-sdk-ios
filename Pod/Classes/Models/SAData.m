//
//  SAData.m
//  Pods
//
//  Created by Gabriel Coman on 15/04/2016.
//
//

#import "SAData.h"
#import "SAVASTAd.h"

@implementation SAData

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super init]) {
        _adHTML = [jsonDictionary safeStringForKey:@"adHTML"];
        _imagePath = [jsonDictionary safeStringForKey:@"imagePath"];
        _vastAd = [[SAVASTAd alloc] initWithJsonDictionary:[jsonDictionary objectForKey:@"vastAd"]];
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"adHTML": nullSafe(_adHTML),
        @"imagePath": nullSafe(_imagePath),
        @"vastAd": nullSafe([_vastAd dictionaryRepresentation])
    };
}

@end
