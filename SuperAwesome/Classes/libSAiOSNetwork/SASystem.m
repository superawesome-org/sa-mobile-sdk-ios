//
//  SASystem.m
//  libSAiOSAdUtils
//
//  Created by Gabriel Coman on 01/12/2015.
//
//

#import "SASystem.h"

@implementation SASystem

+ (SASystemType) getSystemType {
    return type_ios;
}

+ (SASystemSize) getSystemSize {
    BOOL isIpad = [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"];
    
    if (isIpad) {
        return size_tablet;
    } else {
        return size_mobile;
    }
}

+ (NSString*) getVerboseSystemDetails {
    NSMutableString *printer = [[NSMutableString alloc] init];
    
    SASystemType _stype = [SASystem getSystemType];
    SASystemSize _ssize = [SASystem getSystemSize];
    
    switch (_stype) {
        case type_ios: [printer appendString:@"ios"]; break;
        default: [printer appendString:@"undefined"]; break;
    }
    
    [printer appendString:@"_"];
    
    switch (_ssize) {
        case size_mobile: [printer appendString:@"mobile"]; break;
        case size_tablet: [printer appendString:@"tablet"]; break;
        default: [printer appendString:@"undefined"]; break;
    }
    
    return printer;
}

@end
