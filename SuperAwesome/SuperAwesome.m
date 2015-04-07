//
//  SuperAwesome.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 29/07/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SuperAwesome.h"
#import "SAServerResponse.h"
#import "SAAppConfig.h"

@interface SuperAwesome ()

@property (nonatomic,strong) NSMutableArray *apps;
@property (nonatomic,strong) NSMutableDictionary *queue;

- (NSString *)baseURL;

@end

@implementation SuperAwesome

+ (id)sharedManager
{
    static SuperAwesome *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil){
            sharedManager = [[self alloc] init];
            NSLog(@"%@", [sharedManager version]);
        }
    }
    return sharedManager;
}

- (instancetype)init
{
    if(self = [super init]){
        _clientConfiguration = SAClientConfigurationProduction;
        _apps = [NSMutableArray array];
        _queue = [NSMutableDictionary dictionary];
        [ATBaseConfiguration setLoggingLevel:kATLogOff];
    }
    return self;
}

- (NSString *)version
{
    return @"SuperAwesome iOS SDK version 1.2.0";
}

- (NSString *)baseURL
{
    if(self.clientConfiguration == SAClientConfigurationProduction){
        return @"http://ads.superawesome.tv/ads/";
    }else{
        return @"http://staging.dashboard.superawesome.tv/api/sdk/ads";
    }
}

- (void)configurationForApp:(NSString *)appID completion:(void(^)(SAAppConfig *))completion
{
    // Find app by appID
    SAAppConfig *app = nil;
    for(SAAppConfig *item in self.apps){
        if([item.appID isEqualToString:appID]){
            app = item;
            break;
        }
    }
    
    // App is already in array
    if(app != nil){
        if(completion != nil){
            if(app.isLoading){
                NSMutableArray *appQueue = [self.queue objectForKey:appID];
                if(appQueue == nil){
                    appQueue = [NSMutableArray arrayWithObject:completion];
                    [self.queue setObject:appQueue forKey:appID];
                }else{
                    [appQueue addObject:completion];
                }
            }else{
                completion(app);
            }
        }
        
    //Load app configuration from dashboard
    }else{
        app = [[SAAppConfig alloc] init];
        app.appID = appID;
        app.loading = YES;
        [self.apps addObject:app];
        [self loadAppConfig:app completion:^(NSError *error) {
            app.loading = NO;
            completion(app);
            NSMutableArray *appQueue = [self.queue objectForKey:appID];
            for(void (^ myblock)(SAAppConfig *) in appQueue){
                myblock(app);
            }
            if(error){
                [self.apps removeObject:app];
            }
        }];
    }
}

- (void)loadAppConfig:(SAAppConfig *)appConfig completion:(void(^)(NSError *error))completion
{
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:self.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: appConfig.appID, @"app_id", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        SAServerResponse *resp = [[SAServerResponse alloc] initWithData:data error:&error];
        if(resp == nil){
            NSLog(@"SA: Could not load app configuration (%@)", error.localizedDescription);
            completion(error);
        }else{
            if(resp.success){
                NSLog(@"SA: App configuration has been loaded successfully (%@)", appConfig.appID);
//                NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"%@", dataStr);
                appConfig.displayAds = resp.ads;
                appConfig.videoAds = resp.prerolls;
                [appConfig dumpPlacements];
                completion(nil);
            }else{
                NSLog(@"SA: Could not load app configuration (%@)", resp.errorMessage);
                completion([NSError errorWithDomain:@"SADashboard" code:[resp.errorCode integerValue] userInfo:@{}]);
            }
        }
    }];
    
    [postDataTask resume];
    
}

- (void)displayAdForApp:(NSString *)appID placement:(NSString *)placementID completion:(void(^)(SADisplayAd *))completion
{
    [self configurationForApp:appID completion:^(SAAppConfig *appConfig) {
        completion([appConfig displayAdByPlacementID:placementID]);
    }];
}

- (void)videoAdForApp:(NSString *)appID placement:(NSString *)placementID completion:(void(^)(SAVideoAd *))completion
{
    [self configurationForApp:appID completion:^(SAAppConfig *appConfig) {
        completion([appConfig videoAdByPlacementID:placementID]);
    }];
}

@end
