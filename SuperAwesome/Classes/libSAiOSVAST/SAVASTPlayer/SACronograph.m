//
//  SACronograph.m
//  TestVASTParser
//
//  Created by Gabriel Coman on 15/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "SACronograph.h"

//
// @brief: Category for label
@interface UILabel (Chronograph)
+ (UILabel*)createChrono;
@end

@implementation UILabel (Cronograph)

+ (UILabel*) createChrono {
    UILabel *chrono = [[UILabel alloc] init];
    
    chrono.backgroundColor = [UIColor clearColor];
    chrono.textColor = [UIColor whiteColor];
    chrono.font = [UIFont systemFontOfSize:10];
    chrono.textAlignment = NSTextAlignmentCenter;
    
    return chrono;
}

@end

@interface SACronograph ()

// parent frame
@property (nonatomic, assign) CGRect parentFrame;

// subviews
@property (nonatomic, strong) UILabel *adLabel;
@property (nonatomic, strong) UILabel *remainingLabel;

@end

@implementation SACronograph

// customize init
- (id) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) didMoveToSuperview {
    // get the parent frame
    _parentFrame = self.superview.frame;
    
    // setup own frame
    CGFloat H = 20.0f;
    CGFloat W = _parentFrame.size.width - 20.0f;
    CGFloat X = 10.0f;
    CGFloat Y = _parentFrame.size.height - 30.0f;
    self.frame = CGRectMake(X, Y, W, H);
    
    // add the two other label
    _adLabel = [UILabel createChrono];
    _adLabel.text = @"Ad: ";
    _adLabel.frame = CGRectMake(0, 0, 20, 20);
    [self addSubview:_adLabel];
    
    _remainingLabel = [UILabel createChrono];
    _remainingLabel.frame = CGRectMake(20, 0, 30, 20);
    [self addSubview:_remainingLabel];
}

- (void) setTime:(NSInteger)current andMax:(NSInteger)max {
    NSInteger remaining = max - current;
    _remainingLabel.text = [NSString stringWithFormat:@"%ld", remaining];
}

@end
