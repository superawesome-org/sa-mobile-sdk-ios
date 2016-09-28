//
//  SAGameWallParser.m
//  Pods
//
//  Created by Gabriel Coman on 28/09/2016.
//
//

#import "SAGameWallParser.h"

// import headers
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"

// get the file downloader
#import "SAFileDownloader.h"

@implementation SAGameWallParser

- (void) getGameWallResourcesForAds:(NSArray *)ads andCallback:(gotAllImages)callback {
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
        
        // create the image
        NSArray *components = [ad.creative.details.media.playableMediaUrl componentsSeparatedByString:@"."];
        NSString *ext = @"png";
        if ([components count] > 0) {
            ext = [components lastObject];
        }
        ad.creative.details.media.playableDiskUrl = [SAFileDownloader getDiskLocation:ext];
        
        // download the image
        SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
        [downloader downloadFileFrom:ad.creative.details.media.playableMediaUrl to:ad.creative.details.media.playableDiskUrl withResponse:^(BOOL success) {
            // mark as on disk
            ad.creative.details.media.isOnDisk = success;
            
            // call this func recursively
            [self getImages:(index + 1) max:max ads:ads callback:callback];
        }];
    }
}

@end
