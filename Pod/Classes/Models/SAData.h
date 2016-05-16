//
//  SAData.h
//  Pods
//
//  Created by Gabriel Coman on 15/04/2016.
//
//

#import <Foundation/Foundation.h>

// forward declarations
@class SAVASTAd;

@interface SAData : NSObject

//
// the HTML string
@property (nonatomic, strong) NSString *adHTML;

//
// the path to the image
@property (nonatomic, strong) NSString *imagePath;

//
// the path to the video
@property (nonatomic, strong) SAVASTAd *vastAd;

@end
