//
//  SADetails.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import "SADetails.h"

#import "SAData.h"

@implementation SADetails

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super init]) {
        _width = [jsonDictionary safeIntForKey:@"width"];
        _height = [jsonDictionary safeIntForKey:@"height"];
        _image = [jsonDictionary safeStringForKey:@"image"];
        _value = [jsonDictionary safeIntForKey:@"value"];
        _name = [jsonDictionary safeStringForKey:@"name"];
        _video = [jsonDictionary safeStringForKey:@"video"];
        _bitrate = [jsonDictionary safeIntForKey:@"bitrate"];
        _duration = [jsonDictionary safeIntForKey:@"duration"];
        _vast = [jsonDictionary safeStringForKey:@"vast"];
        _tag = [jsonDictionary safeStringForKey:@"tag"];
        _zipFile = [jsonDictionary safeStringForKey:@"zipFile"];
        _url = [jsonDictionary safeStringForKey:@"url"];
        _placementFormat = [jsonDictionary safeStringForKey:@"placementFormat"];
        _data = [[SAData alloc] initWithJsonDictionary:[jsonDictionary objectForKey:@"data"]];
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"width": @(_width),
        @"height": @(_height),
        @"image": nullSafe(_image),
        @"value": @(_value),
        @"name": nullSafe(_name),
        @"video": nullSafe(_video),
        @"bitrate": @(_bitrate),
        @"duration": @(_duration),
        @"vast": nullSafe(_vast),
        @"tag": nullSafe(_tag),
        @"zipFile": nullSafe(_zipFile),
        @"url": nullSafe(_url),
        @"placementFormat": nullSafe(_placementFormat),
        @"data": nullSafe([_data dictionaryRepresentation])
    };
}

@end
