//
//  SAUnityLinkerCallbacks.h
//  Pods
//
//  Created by Gabriel Coman on 20/01/2016.
//
//

#import <Foundation/Foundation.h>

// callback for generic success with data
typedef void (^adEvent)(NSString *unityAd, NSString *unityCallback);

// callback for generic success with data
typedef void (^loadingEvent)(NSString *unityAd, NSString *unityCallback, NSString *adString);

