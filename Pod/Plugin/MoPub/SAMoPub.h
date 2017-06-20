/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>

// SA MoPub JSON dictionary values
#define PLACEMENT_ID                        @"placementId"
#define TEST_ENABLED                        @"isTestEnabled"
#define PARENTAL_GATE                       @"isParentalGateEnabled"
#define ORIENTATION                         @"orientation"
#define CONFIGURATION                       @"configuration"
#define SHOULD_SHOW_CLOSE                   @"shouldShowCloseButton"
#define SHOULD_AUTO_CLOSE                   @"shouldAutomaticallyCloseAtEnd"
#define VIDEO_BUTTON_STYLE                  @"shouldShowSmallClickButton"

// SA MoPub error values
#define ERROR_DOMAIN                        @"SuperAwesomeErrorDomain"
#define ERROR_CODE                          0
#define ERROR_JSON_TITLE                    @"Failed to get correct custom data from MoPub server."
#define ERROR_JSON_MESSAGE                  @"Either \"isTestEnabled\" or \"placementId\" parameters are wrong."
#define ERROR_JSON_SUGGESTION               @"Make sure your custom data JSON has at least: { \"placementId\":XXX, \"isTestEnabled\":true/false }"
#define ERROR_LOAD_TITLE(type, placementId) [NSString stringWithFormat:@"Failed to load SuperAwesome %@ for PlacementId: %ld", type, (long)placementId]
#define ERROR_LOAD_MESSAGE                  @"There is no Ad data for this placement"
#define ERROR_LOAD_SUGGESTION               @"Contact SuperAwesome support: <devsupport@superawesome.tv>"
#define ERROR_NETWORK_MESSAGE               @"There was a network error trying to load this ad."
#define ERROR_NETWORK_SUGGESTION            @"Contact SuperAwesome support: <devsupport@superawesome.tv>"
#define ERROR_SHOW_TITLE(type, placementId) [NSString stringWithFormat:@"Failed to display SuperAwesome %@ for PlacementId: %ld", type, (long)placementId]
#define ERROR_SHOW_MESSAGE                  @"Ad failed to display for some reason"
#define ERROR_SHOW_SUGGESTION               @"Contact SuperAwesome support: <devsupport@superawesome.tv>"

