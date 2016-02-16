//
//  SACapper.m
//  Pods
//
//  Created by Gabriel Coman on 16/02/2016.
//
//

#import "SACapper.h"

#define SUPER_AWESOME_FIRST_PART_DAU @"SUPER_AWESOME_FIRST_PART_DAU"

// this thing right here imports AdSupport framework
@import AdSupport;

@interface SACapper ()
@property (nonatomic, assign) NSUInteger dauHash;
@end

@implementation SACapper

// generates a unique per device / per app / per user ID
// that is COPPA compliant
- (NSString*) generateFirstPartOfDAU {
    // constants
    const NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    const NSInteger length = [alphabet length];
    const NSInteger dauLength = 32;
    
    // create the string
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < dauLength; i++) {
        u_int32_t r = arc4random() % length;
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    return s;
}

// generate the second part of the DAU, which is the IDFA string
- (NSString*) generateSecondPartOfDAU {
    if ([self shouldTrackAdvertising]) {
        NSUUID *idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        return [idfa UUIDString];
    }
    
    return @"";
}

- (BOOL) shouldTrackAdvertising {
    return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
}

// create the Device App User Id
- (void) enableDeviceAppUserId {
    if (![self shouldTrackAdvertising]) {
        _dauHash = 0;
        return;
    }
    
    // get user defaults
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    // get the first part of dau
    NSString *firstPartDau = [def objectForKey:SUPER_AWESOME_FIRST_PART_DAU];
    
    if (!firstPartDau || [firstPartDau isEqualToString:@""]){
        firstPartDau = [self generateFirstPartOfDAU];
        [def setObject:firstPartDau forKey:SUPER_AWESOME_FIRST_PART_DAU];
        [def synchronize];
    }
    
    NSUInteger hash1 = [firstPartDau hash];
    NSUInteger hash2 = [[self generateSecondPartOfDAU] hash];
    _dauHash = hash1 ^ hash2;
}

- (NSUInteger) getDAUId {
    return _dauHash;
}

@end
