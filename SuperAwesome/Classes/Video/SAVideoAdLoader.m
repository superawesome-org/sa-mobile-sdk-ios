//
//  SAVideoAdLoader.m
//  Pods
//
//  Created by Balázs Kiss on 20/04/15.
//
//

#import "SAVideoAdLoader.h"
#import "SuperAwesome.h"

@interface SAVideoAdLoader ()

@property (nonatomic,strong) NSString *placementID;
@property (nonatomic,strong) IMAAdsLoader *adsLoader;

@end

@implementation SAVideoAdLoader

- (instancetype)initWithPlacementID:(NSString *)placementID
{
    if (self = [super init]){
        _placementID = placementID;
        _adDisplayContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        _loading = YES;
        _success = NO;
    }
    return self;
}

- (void)load
{
//    [[SuperAwesome sharedManager] videoAdForApp:self.appID placement:self.placementID completion:^(SAVideoAd *videoAd) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(videoAd == nil){
//                NSLog(@"SA: Could not find placement with the provided ID");
//                if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToLoadVideoAd:)]){
//                    [self.delegate didFailToLoadVideoAd:self];
//                }
//            }else{
//                [self requestAdsWithVideoAd:videoAd];
//            }
//        });
//    }];
}


- (void)requestAdsWithVAST:(NSString *)vastURL
{
    IMAAdDisplayContainer *adDisplayContainer = [[IMAAdDisplayContainer alloc] initWithAdContainer:self.adDisplayContainer companionSlots:nil];
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:vastURL adDisplayContainer:adDisplayContainer userContext:nil];
    
    IMASettings *settings = [[IMASettings alloc] init];
    settings.ppid = @"IMA_PPID_0";
    settings.language = @"en";
    
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:settings];
    self.adsLoader.delegate = self;
    [self.adsLoader requestAdsWithRequest:request];
}


#pragma mark AdLoader

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    NSLog(@"SA: Ad loaded");
    
    _loading = NO;
    _success = YES;
    
    self.adsManager = adsLoadedData.adsManager;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadVideoAd:)]){
        [self.delegate didLoadVideoAd:self];
    }    
}

- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    NSLog(@"SA: Ad loading error: %@", adErrorData.adError.message);
    
    _loading = NO;
    _success = NO;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToLoadVideoAd:)]){
        [self.delegate didFailToLoadVideoAd:self];
    }
}


@end
