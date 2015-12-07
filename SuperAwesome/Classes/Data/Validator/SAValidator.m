//
//  SAValidator.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import "SAValidator.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

@implementation SAValidator

+ (BOOL) isAdDataValid:(SAAd *)ad {
    
    // 0. if is null
    if (ad == NULL)
        return false;
    
    // 1. if Ad has no Creative, data is not valid
    if (ad.creative == NULL)
        return false;
    
    if (ad.creative != NULL) {
        // 2. if format is unknown, data is not valid
        if (ad.creative.format == invalid)
            return false;
        
        // 3. if creative has no details, data is not valid
        if (ad.creative.details == NULL)
            return false;
        
        if (ad.creative.details != NULL) {
            switch (ad.creative.format) {
                case image:{
                    // 4.1. if Ad is image with link, but no image filed
                    // could be found, data is not valid
                    if (ad.creative.details.image == NULL)
                        return false;
                    break;
                }
                case video:{
                    // 4.2. if Ad is video and either the video or the vast
                    // tags could not be found, data is not valid
                    if (ad.creative.details.vast == NULL)
                        return false;
                    break;
                }
                case rich:{
                    // 4.3. if Ad is rich media and no url can be found,
                    // then data is not valid
                    if (ad.creative.details.url == NULL)
                        return false;
                    break;
                }
                case tag:{
                    // 4.4. if Ad is rich media (resizing) and no url can be found,
                    // then data is not valid
                    if (ad.creative.details.tag == NULL)
                        return false;
                    break;
                }
                default:{
                    break;
                }
            }
        }
    }
    
    return true;
}

@end
