//
//  SuperAwesomeMoPub.h
//  Pods
//
//  Created by Gabriel Coman on 10/05/2016.
//
//

#import <Foundation/Foundation.h>

// SA MoPub JSON dictionary values
#define PLACEMENT_ID @"placementId"
#define TEST_ENABLED @"isTestEnabled"
#define PARENTAL_GATE @"isParentalGateEnabled"
#define SHOULD_LOCK @"shouldLockOrientation"
#define LOCK_ORIENTATION @"lockOrientation"
#define SHOULD_SHOW_CLOSE @"shouldShowCloseButton"
#define SHOULD_AUTO_CLOSE @"shouldAutomaticallyCloseAtEnd"

// SA MoPub error values
#define ERROR_DOMAIN @"SuperAwesomeErrorDomain"
#define ERROR_CODE 0
#define ERROR_JSON_TITLE @"Failed to get correct custom data from MoPub server."
#define ERROR_JSON_MESSAGE @"Either \"testMode\" or \"placementId\" parameters are wrong."
#define ERROR_JSON_SUGGESTION @"Make sure your custom data JSON has at least: { \"placementId\":XXX, \"isTestEnabled\":true/false }"
#define ERROR_LOAD_TITLE(type, placementId) [NSString stringWithFormat:@"Failed to load SuperAwesome %@ for PlacementId: %ld", type, (long)placementId]
#define ERROR_LOAD_MESSAGE @"There is no Ad data for this placement"
#define ERROR_LOAD_SUGGESTION @"Contact SuperAwesome support: <devsupport@superawesome.tv>"
#define ERROR_SHOW_TITLE(type, placementId) [NSString stringWithFormat:@"Failed to display SuperAwesome %@ for PlacementId: %ld", type, (long)placementId]
#define ERROR_SHOW_MESSAGE @"Ad failed to display for some reason"
#define ERROR_SHOW_SUGGESTION @"Contact SuperAwesome support: <devsupport@superawesome.tv>"

