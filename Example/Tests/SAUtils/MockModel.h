//
//  TestClass.h
//  SAUtils
//
//  Created by Gabriel Coman on 02/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MockModel : NSObject

@property (nonatomic, assign) BOOL isOK;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger pay;

- (id) initWithName:(NSString*)name andIsOK:(BOOL)isOK andPay:(NSInteger)pay;
@end
