//
//  SAUtils.m
//  libSAiOSUtils
//
//  Created by Gabriel Coman on 02/12/2015.
//
//

#import "SAUtils.h"

@implementation SAUtils

+ (CGRect) arrangeAdInNewFrame:(CGRect)frame fromFrame:(CGRect)oldframe {
    
    CGFloat newW = frame.size.width;
    CGFloat newH = frame.size.height;
    CGFloat oldW = oldframe.size.width;
    CGFloat oldH = oldframe.size.height;
    if (oldW == 1 || oldW == 0) { oldW = newW; }
    if (oldH == 1 || oldH == 0) { oldH = newH; }
    
    CGFloat oldR = oldW / oldH;
    CGFloat newR = newW / newH;
    
    CGFloat X = 0, Y = 0, W = 0, H = 0;
    
    if (oldR > newR) {
        W = newW;
        H = W / oldR;
        X = 0;
        Y = (newH - H) / 2.0f;
    }
    else {
        H = newH;
        W = H * oldR;
        Y = 0;
        X = (newW - W) / 2.0f;
    }
    
    return CGRectMake(X, Y, W, H);
}

+ (NSInteger) randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    return min + arc4random_uniform((uint32_t)(max - min + 1));
}

+ (NSString*) findSubstringFrom:(NSString*)source betweenStart:(NSString*)start andEnd:(NSString*)end {
    NSRange startRange = [source rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [source length] - targetRange.location;
        NSRange endRange = [source rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [source substringWithRange:targetRange];
        }
    }
    
    // if it gets to here there is no substring, and just return
    return nil;
}

@end
