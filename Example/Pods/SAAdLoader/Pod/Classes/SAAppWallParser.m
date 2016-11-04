//
//  SAGameWallParser.m
//  Pods
//
//  Created by Gabriel Coman on 28/09/2016.
//
//

#import "SAAppWallParser.h"

// import headers
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"

// get the file downloader
#import "SAFileDownloader.h"

@implementation SAAppWallParser

- (void) getAppWallResourcesForAds:(NSArray *)ads andCallback:(gotAllImages)callback {
    NSInteger max = [ads count];
    NSInteger first = 0;
    [self getImages:first max:max ads:ads callback:callback];
}

- (void) getImages: (NSInteger) index max: (NSInteger) max ads: (NSArray<SAAd*> *)ads callback: (gotAllImages) callback {
    if (index > max - 1) {
        if (callback != nil) {
            callback ();
        }
    } else {
        // get the ad
        __block SAAd *ad = (SAAd*)[ads objectAtIndex:index];
        ad.creative.details.media.playableMediaUrl = ad.creative.details.image;
        
        // download the image
        [[SAFileDownloader getInstance] downloadFileFrom:ad.creative.details.media.playableMediaUrl
                                             andResponse:^(BOOL success, NSString *diskPath) {
        
                                                 ad.creative.details.media.isOnDisk = success;
                                                 ad.creative.details.media.playableDiskUrl = diskPath;
                                                 
                                                 // call this func recursively
                                                 [self getImages:(index + 1) max:max ads:ads callback:callback];
                                                 
                                             }];
    }
}

@end
