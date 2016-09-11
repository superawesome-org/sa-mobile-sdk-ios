////
////  SAUnityLinkerManager.m
////  Pods
////
////  Created by Gabriel Coman on 04/02/2016.
////
////
//
//#import "SAUnityExtensionContext.h"
//
//@interface SAUnityExtensionContext ()
//
//// a dictionary of ads
//@property (nonatomic, strong) NSMutableDictionary *adsDictionary;
//
//@end
//
//@implementation SAUnityExtensionContext
//
//+ (SAUnityExtensionContext *)getInstance {
//    static SAUnityExtensionContext *sharedManager = nil;
//    @synchronized(self) {
//        if (sharedManager == nil){
//            sharedManager = [[self alloc] init];
//        }
//    }
//    return sharedManager;
//}
//
//- (instancetype) init {
//    if (self = [super init]) {
//        // init the mutable dictionary
//        _adsDictionary = [[NSMutableDictionary alloc] init];
//    }
//    
//    return self;
//}
//
//- (void) setAd:(NSObject *)adView forKey:(NSString *)key {
//    [_adsDictionary setObject:adView forKey:key];
//}
//
//- (NSObject*) getAdForKey:(NSString *)key {
//    return [_adsDictionary objectForKey:key];
//}
//
//- (NSString*) getKeyForId:(NSInteger)placementId {
//    
//    __block NSString *desiredKey = nil;
//    
//    [_adsDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSInteger p = 0;
//        if ([obj isKindOfClass:[SABannerAd class]]) {
//            SABannerAd *banner = (SABannerAd*)obj;
//            p = [banner getAd].placementId;
//        } else if ([obj isKindOfClass:[SAInterstitialAd class]]) {
//            SAInterstitialAd *interstitial = (SAInterstitialAd*)obj;
//            p = [interstitial getAd].placementId;
//        } else if ([obj isKindOfClass:[SAVideoAd class]]) {
//            SAVideoAd *video = (SAVideoAd*)obj;
//            p = [video getAd].placementId;
//        }
//        
//        if (p == placementId) {
//            desiredKey = (NSString*)key;
//        }
//    }];
//
//    return desiredKey;
//}
//
//- (void) removeAd:(NSInteger)placementId {
//    NSString *key = [self getKeyForId:placementId];
//    if (key) {
//        [_adsDictionary removeObjectForKey:key];
//    }
//}
//
//@end
