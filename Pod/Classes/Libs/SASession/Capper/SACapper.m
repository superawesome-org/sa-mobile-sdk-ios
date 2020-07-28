/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SACapper.h"

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

// define the key under which the first part of the whole DAU int will be
// stored in local storage
#define SUPER_AWESOME_SECOND_PART_DAU @"SUPER_AWESOME_FIRST_PART_DAU"

@implementation SACapper



- (NSUInteger) getDauId {
    
    // get the user defaults
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    // get the first part of the DAU, from the current date as MM/yyyy
    NSString *firstPartOfDAU = MonthYearStringFromDate(NSDate.new);
    
    // get the second part of the DAU, the library generated 32-character
    // alpha numeric unique string
    NSString *secondPartOfDAU = [defs objectForKey:SUPER_AWESOME_SECOND_PART_DAU];
    
    // get the third part of the DAU, the current bundle name
    NSString *thirdPartOfDAU = [[NSBundle mainBundle] bundleIdentifier];
    
    // if the second part, the library generated unique string does not exist,
    // then generate and save it for future reference
    if (!secondPartOfDAU || [secondPartOfDAU isEqualToString:@""]){
        secondPartOfDAU = [SAUtils generateUniqueKey];
        [defs setObject:secondPartOfDAU forKey:SUPER_AWESOME_SECOND_PART_DAU];
        [defs synchronize];
    }
    
    // get integer hashes for all dau parts
    NSUInteger hash1 = [firstPartOfDAU hash];
    NSUInteger hash2 = [secondPartOfDAU hash];
    NSUInteger hash3 = [thirdPartOfDAU hash];
    
    // finally return them hashed
    return hash1 ^ hash2 ^ hash3;
}

@end
