//
//  SAData.h
//  Pods
//
//  Created by Gabriel Coman on 15/04/2016.
//
//

#import <Foundation/Foundation.h>

@interface SAData : NSObject

//
// the HTML string
@property (nonatomic, strong) NSString *adHTML;

//
// the path to the video
@property (nonatomic, strong) NSString *videoPath;

//
// the path to the image
@property (nonatomic, strong) NSString *imagePath;

// print function
- (NSString*) print;

@end
