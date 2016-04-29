//
//  SALoader.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

// import header
#import "SALoader.h"

// import other headers
#import "SAParser.h"
#import "SAHTMLParser.h"
#import "SAVASTParser.h"

// import model headers
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import SA main Singleton
#import "SuperAwesome.h"
#import "NSObject+ModelToString.h"

// import Aux class
#import "SAUtils.h"

@interface SALoader ()
@end

@implementation SALoader

- (void) loadAdForPlacementId:(NSInteger)placementId {
    
    // First thing to do is format the AA URL to get an ad, based on specs
    NSString *endpoint = [NSString stringWithFormat:@"%@/ad/%ld", [[SuperAwesome getInstance] getBaseURL], (long)placementId];
    NSDictionary *dict = @{
        @"test": @([[SuperAwesome getInstance] isTestingEnabled]),
        @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
        @"rnd":@([SAUtils getCachebuster]),
        @"bundle":[[NSBundle mainBundle] bundleIdentifier],
        @"name":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],
        @"dauid":@([[SuperAwesome getInstance] getDAUID])
    };
    
    // The second operation to perform is calling a SANetwork class function
    // to get Ad data, returned as NSData
    [SAUtils sendGETtoEndpoint:endpoint withQueryDict:dict andSuccess:^(NSData *data) {
        
        // create parser & extra
        SAParser *parser = [[SAParser alloc] init];
        
        // parse the ad
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Original String %@", str);
        
        __block SAAd *parsedAd = [parser parseInitialAdFromNetwork:data withPlacementId:placementId];
        
        if (!parsedAd) {
            if (_delegate != NULL && [_delegate respondsToSelector:@selector(didFailToLoadAdForPlacementId:)]){
                [_delegate didFailToLoadAdForPlacementId:placementId];
            }
        }
        // and get extra data
        else {
            
            parsedAd.creative.details.data = [[SAData alloc] init];
            SACreativeFormat type = parsedAd.creative.creativeFormat;
            
            switch (type) {
                // parse video
                case video: {
                    SAVASTParser *vastParser = [[SAVASTParser alloc] init];
                    __weak SALoader* weakSelf = self;
                    [vastParser parseVASTURL:parsedAd.creative.details.vast done:^(NSArray *ads) {
                        parsedAd.creative.details.data.vastAds = [ads mutableCopy];
                        if (weakSelf.delegate != NULL && [weakSelf.delegate respondsToSelector:@selector(didLoadAd:)]) {
                            [weakSelf.delegate didLoadAd:parsedAd];
                        }
                    }];
                    break;
                }
                // parse HTML data
                case image:
                case rich:
                case tag:
                case invalid: {
                    parsedAd.creative.details.data.adHTML = [SAHTMLParser formatCreativeDataIntoAdHTML:parsedAd];
                    if (_delegate != NULL && [_delegate respondsToSelector:@selector(didLoadAd:)]) {
                        [_delegate didLoadAd:parsedAd];
                    }
                    break;
                }
            }
        }
    } orFailure:^{
        if (_delegate != NULL && [_delegate respondsToSelector:@selector(didFailToLoadAdForPlacementId:)]) {
            [_delegate didFailToLoadAdForPlacementId:placementId];
        }
    }];
}

@end
