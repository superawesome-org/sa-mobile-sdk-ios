//
//  ADTECHVASTRequest.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/13/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADTECHMobileSDK/ATVideoAdConfiguration.h>

@class ADTECHVASTDocumentParser;
@class ADTECHVASTRequest;
@class ATVASTDocument;

@protocol ADTECHVASTRequestDelegate<NSObject>

- (void)VASTRequest:(ADTECHVASTRequest*)request didSucceedWithDocument:(ATVASTDocument*)document;
- (void)VASTRequest:(ADTECHVASTRequest*)request didFailWithError:(NSError*)error;

@end


@interface ADTECHVASTRequest : NSObject

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, weak) id<ADTECHVASTRequestDelegate> delegate;

- (id)initWithConfiguration:(ATVideoAdConfiguration*)config andAdType:(ATVideoAdType)type;
+ (ADTECHVASTRequest*)VASTRequestWithConfiguration:(ATVideoAdConfiguration*)config andAdType:(ATVideoAdType)type;

- (void)run;
- (void)cancel;

@end
