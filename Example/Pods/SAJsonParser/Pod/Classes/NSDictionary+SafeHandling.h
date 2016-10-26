//
//  NSDictionary+SafeHandling.h
//  Pods
//
//  Created by Gabriel Coman on 31/05/2016.
//
//

#import <Foundation/Foundation.h>

/**
 *  This function makes sure the data you enter in a dictionary object is not
 *  ever going to be NULL or nil; If it's not initialized, a NSNull instance
 *  will be delivered
 *
 *  @param object the object in question
 *
 *  @return either the object or NSNull
 */
__attribute__((unused)) static _Nullable id nullSafe(_Nullable id object) {
    return object ?: [NSNull null];
}

@interface NSDictionary (SafeHandling)

- (_Nullable id) safeObjectForKey:(_Nullable id)aKey;
- (_Nullable id) safeObjectForKey:(_Nullable id)aKey orDefault:(_Nullable id)def;

- (NSInteger) safeIntForKey:(_Nonnull id)aKey;
- (NSInteger) safeIntForKey:(_Nonnull id)aKey orDefault:(NSInteger) def;

- (BOOL) safeBoolForKey:(_Nonnull id)aKey;
- (BOOL) safeBoolForKey:(_Nonnull id)aKey orDefault:(BOOL) def;

- (NSString*) safeStringForKey:(_Nonnull id)aKey;
- (NSString*) safeStringForKey:(_Nonnull id)aKey orDefault:(NSString*)def;

- (float) safeFloatForKey:(_Nonnull id)aKey;
- (float) safeFloatForKey:(_Nonnull id)aKey orDefault:(CGFloat)def;

- (double) safeDoubleForKey:(_Nonnull id)aKey;
- (double) safeDoubleForKey:(_Nonnull id)aKey orDefault:(CGFloat)def;

- (NSDictionary*) safeDictionaryForKey:(_Nonnull id)aKey;
- (NSDictionary*) safeDictionaryForKey:(_Nonnull id)aKey orDefault:(NSDictionary*)def;

- (NSArray*) safeArrayForKey:(_Nonnull id)aKey;
- (NSArray*) safeArrayForKey:(_Nonnull id)aKey orDefault:(NSArray*)def;


@end
