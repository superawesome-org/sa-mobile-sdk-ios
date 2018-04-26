//
//  SAPlaybackMode.h
//  SuperAwesome
//
//  Created by Gabriel Coman on 26/04/2018.
//

#import <UIKit/UIKit.h>

/**
 * Enum defining possible orientations a fullscreen ad may be found in:
 * - POSTROLL
 * - MIDROLL
 * - PREROLL
 * - MIDROLL_WITH_DELAY:
 */
typedef NS_ENUM(NSInteger, SAPlaybackMode) {
    POSTROLL = -2,          // -2
    MIDROLL = -1,           // -1
    PREROLL = 0,            // 0
    MIDROLL_WITH_DELAY = 1  // 1
};

/**
 * Static inline method that sets the orientation starting from an integer
 *
 * @param mode   the integer value
 * @return an enum, based on the int value being passed
 */
static inline SAPlaybackMode getPlaybackModeFromInt (int mode) {
    switch (mode) {
        case -2: return POSTROLL;
        case -1: return MIDROLL;
        case 0: return PREROLL;
        default: {
            return MIDROLL_WITH_DELAY;
        }
    }
}

