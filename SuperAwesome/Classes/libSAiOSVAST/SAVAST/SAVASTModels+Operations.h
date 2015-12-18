//
//  SAVASTModels+Operations.h
//  Pods
//
//  Created by Gabriel Coman on 17/12/2015.
//
//

#import <Foundation/Foundation.h>
#import "SAVASTModels.h"

//
// @brief: This Extensions file create a set of specialised functions that
// perform "add" operation on a number of VAST modelspace objects

@interface SAVASTAd (Operations)

// @brief: this function performs the sum of an Ad over the current Ad
- (void) sumAd:(SAVASTAd*)ad;

@end

@interface SAVASTCreative (Operations)

// @brief: this function perfroms the sum of a Creative over the current Creative
- (void) sumCreative:(SAVASTCreative*)creative;

@end

@interface SALinearCreative (Operations)

// @brief: this function performs the sum of a Linear Creative over the current Linear Creative
- (void) sumCreative:(SALinearCreative*)creative;

@end