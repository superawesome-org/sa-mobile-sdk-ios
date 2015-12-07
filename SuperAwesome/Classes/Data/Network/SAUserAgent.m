//
//  SAUserAgent.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import "SAUserAgent.h"
#import "SASystem.h"

// constants with user agents
#define iOS_Mobile_UserAgent @"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_4 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B350 Safari/8536.25";
#define iOS_Tablet_UserAgent @"Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) CriOS/30.0.1599.12 Mobile/11A465 Safari/8536.25 (3B92C18B-D9DE-4CB7-A02A-22FD2AF17C8F)";

@implementation SAUserAgent

+ (NSString*) getUserAgent {
    
    if ([SASystem getSystemSize] == size_tablet) {
        return iOS_Tablet_UserAgent;
    } else if ([SASystem getSystemSize] == size_mobile) {
        return iOS_Mobile_UserAgent;
    }
    
    return NULL;
}

@end
