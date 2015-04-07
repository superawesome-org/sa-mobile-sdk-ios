//
//  ATVASTErrorCodes.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 04.11.2013.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kATVASTParserErrorDomain;
extern NSString *const kATVASTRequestErrorDomain;
extern NSString *const kATVASTLinearErrorDomain;

extern const NSInteger kATVASTParserErrorCodeCanceled;
extern const NSInteger kATVASTParserErrorCodeMalformed;

extern const NSInteger kATVASTErrorCodeNoLinearMedia;
extern const NSInteger kATVASTErrorCodeNoMediaFilesInLinear;
extern const NSInteger kATVASTErrorCodeFailedLoadingTracks;
extern const NSInteger kATVASTErrorCodeFailedPreparingVideoItem;
extern const NSInteger kATVASTErrorCodeInvalidConfiguration;
extern const NSInteger kATVASTErrorCodeNoNonLinear;
extern const NSInteger kATVASTErrorCodeTooManyWrapperRedirects;
extern const NSInteger kATVASTErrorCodeEmptyCompanionView;
extern const NSInteger kATVASTErrorCodeNoSupportedMediaFileFound;

extern const NSInteger kATVASTErrorCodeEmptyDocument;
extern const NSInteger kATVASTErrorCodeFailedRequest;
extern const NSInteger kATVASTErrorCodeFailedParsing;
extern const NSInteger kATVASTErrorCodeVASTVersionUnsupported;

extern const NSInteger kATVASTErrorCodeInvalidTimeInterval;

