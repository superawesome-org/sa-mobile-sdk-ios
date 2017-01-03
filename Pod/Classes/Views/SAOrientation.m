//
//  SAOrientation.c
//  Pods
//
//  Created by Gabriel Coman on 03/01/2017.
//
//

#import "SAOrientation.h"

SAOrientation getOrientationFromInt (int orientation) {
    if (orientation == 2) return LANDSCAPE;
    if (orientation == 1) return PORTRAIT;
    return ANY;
}
