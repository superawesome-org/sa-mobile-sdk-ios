//
//  ATVASTEnums.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 4/20/12.
//  Copyright (c) 2012 ADTECH AG. All rights reserved.
//

#ifndef ADTECHMobileSDK_ATVASTEnums_h
#define ADTECHMobileSDK_ATVASTEnums_h

typedef NS_ENUM(NSUInteger, ATVASTTriState)
{
    kATVASTNotSet,
    kATVASTTrue,
    kATVASTFalse,
};

typedef NS_ENUM(NSUInteger, ATVASTTrackingEvent)
{
    kATTrackingEventInvalid,
    kATTrackingEventCreativeView,
    kATTrackingEventStart,
    kATTrackingEventMidpoint,
    kATTrackingEventFirstQuartile,
    kATTrackingEventThirdQuartile,
    kATTrackingEventComplete,
    kATTrackingEventMute,
    kATTrackingEventUnmute,
    kATTrackingEventPause,
    kATTrackingEventRewind,
    kATTrackingEventResume,
    kATTrackingEventFullscreen,
    kATTrackingEventExitFullscreen,
    kATTrackingEventExpand,
    kATTrackingEventCollapse,
    kATTrackingEventAcceptInvitation,
    kATTrackingEventAcceptInvitationLinear,
    kATTrackingEventClose,
    kATTrackingEventCloseLinear,
    kATTrackingEventSkip,
    kATTrackingEventProgress,
    
    // ADTECH extension for events.
    kATTrackingEventNonIABReplay,
    kATTrackingEventNonIABStop,
    
};

typedef NS_ENUM(NSUInteger, ATVASTProprietaryExtensionType)
{
    kATVASTExtensionTypeUnknown = 0,
    kATVASTExtensionTypeMidRollStartTime = 1,
	kATVASTExtensionTypeLinearSkipTime = 2,
    
};

/**
 * The display requirement for the companion views
 *
 * @since 3.6
 */
typedef NS_ENUM(NSUInteger, ATVASTCompanionDisplayRequirement)
{
    /** No requirement was specified in the ad response */
    DisplayRequirementUnspecified,
    /** At least one of the provided companions must be displayed by the video player */
    DisplayRequirementAny,
    /** All the provided companions must be displayed by the video player */
    DisplayRequirementAll,
    /** Any or no companions could be displayed by the video player */
	DisplayRequirementNone,
};

typedef NS_ENUM(NSUInteger, ATVASTCreativeType)
{
    CreativeTypeInvalid,
    CreativeTypeLinear,
    CreativeTypeCompanion,
    CreativeTypeNonLinear,
};

#endif
