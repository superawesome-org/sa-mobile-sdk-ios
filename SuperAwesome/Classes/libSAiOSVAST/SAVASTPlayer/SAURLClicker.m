//
//  SAURLClicker.m
//  Pods
//
//  Created by Gabriel Coman on 17/12/2015.
//
//

#import "SAURLClicker.h"

@implementation SAURLClicker

- (id) init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void) didMoveToSuperview {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:@"Find out more" forState:UIControlStateNormal];
    
    CGRect parentFrame = self.superview.frame;
    self.frame = CGRectMake(5, 5, parentFrame.size.width - 10, 20);
    
    [[self titleLabel] setFont:[UIFont systemFontOfSize:12]];
    [self setTitleColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

@end
