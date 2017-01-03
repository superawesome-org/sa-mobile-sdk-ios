//
//  SADefines.h
//  Pods
//
//  Created by Gabriel Coman on 15/09/2016.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SAOrientation) {
    ANY = 0,
    PORTRAIT = 1,
    LANDSCAPE = 2
};

static inline SAOrientation getOrientationFromInt (int orientation) {
    if (orientation == 2) return LANDSCAPE;
    if (orientation == 1) return PORTRAIT;
    return ANY;
}
