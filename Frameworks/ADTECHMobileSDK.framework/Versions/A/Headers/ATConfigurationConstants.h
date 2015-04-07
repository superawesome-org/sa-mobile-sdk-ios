//
//  ATConfigurationConstants.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 6/7/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @since 1.0
 */
typedef NS_ENUM(NSUInteger, ATLogLevel)
{
    /** no logging will be done. */
    kATLogOff,
    
    /** only errors will be logged. */
    kATLogError,
    
    /** errors and warnings will be logged. */
    kATLogWarning,
    
    /** errors, warnings and general information will be logged. */
    kATLogInfo,
    
    /** detailed logging. */
    kATLogVerbose,
    
    /** complete logging. */
    kATLogVerbosePlus
};

/// the error domain passed on when an error occures
extern NSString *kATConfigErrorDomain;


/// the generic error code passed on when an undefined error occures
extern const int kATConfigGenericError;

/// the error code passed when the key is empty
extern const int kATConfigEmptyKeyError;

/// the error code passed when the key is nil
extern const int kATConfigNilKeyError;

/// the error code passed when the key is not found
extern const int kATConfigKeyNotFoundError;

/// the error code passed when the values passed are empty
extern const int kATConfigEmptyValuesError;

/// the error code passed when an invalid char is used
extern const int kATConfigInvalidCharError;

/// the error code passed when the value is not string
extern const int kATConfigValueNotStringError;

/// the error code passed when the max allowed length is exceeded
extern const int kATConfigMaxLengthExcededError;

/// the error code passed when the max allowed count for key-value pairs is exceeded
extern const int kATConfigMaxKVPairsExcededError;

/// the error code passed when the max allowed tokens count per one key is exceeded
extern const int kATConfigMaxValueTokensPerKeyExcededError;


/// the HTTP scheme used for domain where events are sent
extern NSString *const kATProtocolSchemaHTTP;

/// the HTTPS scheme used for domain where events are sent
extern NSString *const kATProtocolSchemaHTTPS;

/**
 * The available types of resize behavior on ad resize.
 *
 * @since 3.4.
 */
typedef NS_ENUM(NSUInteger, ResizeBehavior)
{
    /** Inline behavior means the banner will fit the size of the ad inside it. */
    ResizeBehaviorInline,
    
    /** Overlay behavior means the ad might extend beyonds the bounds of the banner. */
    ResizeBehaviorOverlay
};

/**
 * The available location reporting modes.
 *
 * @since 3.5.2
 */
typedef NS_ENUM(NSUInteger, ATLocationReportingMode)
{
    /** Location is not being used by the SDK */
    LocationReportingDisabled,
    
    /** Location is automatically retrieved by the SDK */
    LocationReportingSDK,
    
    /** If provided by the application, location is used by the SDK, but it is not retrieved on its own */
    LocationReportingApp
};
