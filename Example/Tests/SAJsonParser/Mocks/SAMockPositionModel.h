//
//  SAPosition.h
//  SAJsonParser
//
//  Created by Gabriel Coman on 31/05/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SABaseObject.h"

@interface SAMockPositionModel : SABaseObject <SASerializationProtocol, SADeserializationProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger salary;

- (id) initWithName:(NSString*)name andSalary:(NSInteger)salary;

@end
