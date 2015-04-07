//
//  ATAdapTVVideoAdConfiguration_Conversion.h
//  ADTECHMobileSDK
//
//  Created by Balint Dezso on 9/18/14.
//  Copyright (c) 2014 ADTECH GmbH. All rights reserved.
//

#import <ADTECHMobileSDK/ADTECHMobileSDK.h>

@interface ATAdapTVVideoAdConfiguration ()<NSCopying>

- (void)copyValuesFromBaseInstance:(ATVideoAdConfiguration*)instance;

@end
