//
//  SAURLUtils.m
//  libSAiOSAdUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//

#import "SAURLUtils.h"

@implementation SAURLUtils

+ (NSInteger) getCachebuster {
    NSInteger min = 1000000, max = 1500000;
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}

+ (NSString*) formGetQueryFromDict:(NSDictionary *)dict {
    // initial var declaration
    NSMutableString *query = [[NSMutableString alloc] init];
    NSMutableArray *getParams = [[NSMutableArray alloc] init];
    
    // perform operation
    for (NSString *key in dict.allKeys) {
        [getParams addObject:[NSString stringWithFormat:@"%@=%@", key, [dict objectForKey:key]]];
    }
    [query appendString:[getParams componentsJoinedByString:@"&"]];
    
    // return
    return query;
}

+ (NSString*) encodeURI:(NSString*)stringToEncode {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                     (__bridge CFStringRef)stringToEncode,
                                                                     NULL,
                                                                     (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

+ (NSString*) encodeJSONDictionaryFromNSDictionary:(NSDictionary *)dict {
    
    // initial var declaration
    NSMutableString *stringJSON = [[NSMutableString alloc] init];
    NSMutableArray *jsonFields = [[NSMutableArray alloc] init];
    
    // process data
    for (NSObject *key in dict.allKeys) {
        if ([[dict objectForKey:key] isKindOfClass:[NSString class]]){
            [jsonFields addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"", key, [dict objectForKey:key] ]];
        } else {
            [jsonFields addObject:[NSString stringWithFormat:@"\"%@\":%@", key, [dict objectForKey:key] ]];
        }
    }
    [stringJSON appendString:@"{"];
    [stringJSON appendString:[jsonFields componentsJoinedByString:@","]];
    [stringJSON appendString:@"}"];
    
    // return data
    return [self encodeURI:stringJSON];
}

+ (BOOL) isValidURL:(NSObject *)urlObject {
    
    if ([urlObject isKindOfClass:[NSNull class]]) {
        
        return false;
    }
    else if ([urlObject isKindOfClass:[NSString class]]){
        NSString *urlString = (NSString*)urlObject;
        
        NSUInteger length = [urlString length];
        // Empty strings should return NO
        if (length > 0) {
            NSError *error = nil;
            NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
            if (dataDetector && !error) {
                NSRange range = NSMakeRange(0, length);
                NSRange notFoundRange = (NSRange){NSNotFound, 0};
                NSRange linkRange = [dataDetector rangeOfFirstMatchInString:urlString options:0 range:range];
                if (!NSEqualRanges(notFoundRange, linkRange) && NSEqualRanges(range, linkRange)) {
                    if ([urlString isEqualToString:@"http://"] || [urlString isEqualToString:@"https://"]){
                        return false;
                    } else {
                        return true;
                    }
                }
            }
            else {
                NSLog(@"Could not create link data detector: %@ %@", [error localizedDescription], [error userInfo]);
            }
        }
        return false;
    }
    
    return false;
}

@end
