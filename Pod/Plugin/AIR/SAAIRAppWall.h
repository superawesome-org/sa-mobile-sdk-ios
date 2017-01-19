/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"

/**
 * Native method called from AIR that sets up the new app wall. 
 * Usually called once by the AIR SDK
 *
 * @param ctx       current FREContext object
 * @param funcData  pointer to extra data
 * @param argc      argc paramter
 * @param argv[]    argv paramter
 * @return          a new FREObject instance with return data
 */
FREObject SuperAwesomeAIRSAAppWallCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

/**
 * Native method called from AIR that loads a new ad for the app wall
 *
 * @param ctx       current FREContext object
 * @param funcData  pointer to extra data
 * @param argc      argc paramter
 * @param argv[]    argv paramter
 * @return          a new FREObject instance with return data
 */
FREObject SuperAwesomeAIRSAAppWallLoad (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

/**
 * Native method called from AIR that checks if an ad is available for the
 * app wall.
 *
 * @param ctx       current FREContext object
 * @param funcData  pointer to extra data
 * @param argc      argc paramter
 * @param argv[]    argv paramter
 * @return          a new FREObject instance with return data
 */
FREObject SuperAwesomeAIRSAAppWallHasAdAvailable (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

/**
 * Native method called from AIR that plays a certain ap.
 *
 * @param ctx       current FREContext object
 * @param funcData  pointer to extra data
 * @param argc      argc paramter
 * @param argv[]    argv paramter
 * @return          a new FREObject instance with return data
 */
FREObject SuperAwesomeAIRSAAppWallPlay (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
