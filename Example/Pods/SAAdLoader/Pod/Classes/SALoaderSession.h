//
//  SALoaderSession.h
//  Pods
//
//  Created by Gabriel Coman on 02/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface SALoaderSession : NSObject

// singleton instance (instead of init)
+ (SALoaderSession *)getInstance;

- (void) setBaseUrl:(NSString*)baseUrl;
- (void) setDauId:(NSInteger)dauId;
- (void) setTest:(BOOL)test;
- (void) setVersion:(NSString*)version;

- (NSString*) getBaseUrl;
- (NSNumber*) getDauId;
- (NSNumber*) getTest;
- (NSString*) getVersion;

@end
