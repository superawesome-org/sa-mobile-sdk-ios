//
//  SALoaderExtra.h
//  Pods
//
//  Created by Gabriel Coman on 15/04/2016.
//
//

#import <Foundation/Foundation.h>

//
// forward declarations
@class SAAd;

// callback for generic success with data
typedef void (^extraDone)(SAAd *finalAd);

//
// Loader Extra is used for different purposes:
// - for image ads it should download the image
// - for video ads it should parse the vast tag and get the .mp4 file and save it
// - for image, rich media and tag ads it's used to parse the HTML
@interface SALoaderExtra : NSObject

//
// parsing function
- (void) getExtraData:(SAAd*)ad andDone:(extraDone)done;

@end
