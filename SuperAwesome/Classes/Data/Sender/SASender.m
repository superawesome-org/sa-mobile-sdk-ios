//
//  SASender.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

// import header
#import "SASender.h"

// import models
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import util files
#import "SuperAwesome.h"
#import "SANetwork.h"

@implementation SASender

// (private) sa sender function

+ (void) sendEventToURL:(NSString *)url {
    [SANetwork sendGETtoEndpoint:url withQueryDict:@{} andSuccess:^(NSData *data) {} orFailure:^{}];
}

@end
