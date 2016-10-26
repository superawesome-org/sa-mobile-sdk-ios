//
//  NSDictionary+SafeHandling.m
//  Pods
//
//  Created by Gabriel Coman on 31/05/2016.
//
//

#import "NSDictionary+SafeHandling.h"

@implementation NSDictionary (SafeHandling)

// safe get

- (_Nullable id) safeObjectForKey:(_Nullable id)aKey {
    if (aKey == nil || aKey == [NSNull null]) {
        return nil;
    } else {
        NSObject *object = self[aKey];
        
        if (object == [NSNull null]) {
            return nil;
        }
        if (object == nil) {
            return nil;
        }
        
        return object;
    }
}

- (_Nullable id) safeObjectForKey:(_Nullable id)aKey orDefault:(_Nullable id)def {
    id object = [self safeObjectForKey:aKey];
    if (object) {
        return object;
    } else {
        return def;
    }
}

- (NSInteger) safeIntForKey:(_Nonnull id)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    } else {
        return 0;
    }
}

- (NSInteger) safeIntForKey:(_Nonnull id)aKey orDefault:(NSInteger) def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    } else {
        return def;
    }
}

- (BOOL) safeBoolForKey:(_Nonnull id)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    } else {
        return false;
    }
}

- (BOOL) safeBoolForKey:(_Nonnull id)aKey orDefault:(BOOL) def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(boolValue)]) {
        return [object boolValue];
    } else {
        return def;
    }

}

- (NSString*) safeStringForKey:(_Nonnull id)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        return nil;
    }
}

- (NSString*) safeStringForKey:(_Nonnull id)aKey orDefault:(NSString*)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSString class]]) {
        return object;
    } else {
        return def;
    }
}

- (float) safeFloatForKey:(_Nonnull id)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    } else {
        return .0f;
    }
}

- (float) safeFloatForKey:(_Nonnull id)aKey orDefault:(CGFloat)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    } else {
        return def;
    }
}

- (double) safeDoubleForKey:(_Nonnull id)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    } else {
        return .0;
    }
}

- (double) safeDoubleForKey:(_Nonnull id)aKey orDefault:(CGFloat)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSNumber class]] && [object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    } else {
        return def;
    }
}

- (NSDictionary*) safeDictionaryForKey:(_Nonnull id)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)object;
    } else {
        return @{};
    }
}

- (NSDictionary*) safeDictionaryForKey:(_Nonnull id)aKey orDefault:(NSDictionary*)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)object;
    } else {
        return def;
    }
}

- (NSArray*) safeArrayForKey:(_Nonnull id)aKey {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return (NSArray*)object;
    } else {
        return @[];
    }
}

- (NSArray*) safeArrayForKey:(_Nonnull id)aKey orDefault:(NSArray*)def {
    id object = [self safeObjectForKey:aKey];
    if (object && [object isKindOfClass:[NSArray class]]) {
        return (NSArray*)object;
    } else {
        return def;
    }
}

@end
