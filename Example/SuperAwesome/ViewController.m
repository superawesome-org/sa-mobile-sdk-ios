//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"
#import "SAUtils.h"
#import "SASession.h"
#import "SABumperPage.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableArray *abc = @[@(13), @(25), @(88)];
//    [abc removeLastObject];
    
    SASession *session = [[SASession alloc] init];
    [session setConfigurationStaging];
    
    [SABumperPage overrideName:@"Test app"];
    [SABumperPage overrideLogo:[UIImage imageNamed:@"kws_700"]];
    
    [_bannerAd setConfigurationStaging];
    [_bannerAd enableTestMode];
    [_bannerAd disableMoatLimiting];
    [_bannerAd enableParentalGate];
    [_bannerAd enableBumperPage];
    [_bannerAd enableTestMode];
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
       
        NSLog(@"SUPER-AWESOME: Banner Ad %ld - Event %ld", (long)placementId, (long)event);
        
        if (event == adLoaded) {
            [_bannerAd play];
        }
    }];
    
    [SAInterstitialAd setConfigurationProduction];
    [SAInterstitialAd disableTestMode];
//    [SAInterstitialAd enableParentalGate];
//    [SAInterstitialAd enableBumperPage];
    [SAInterstitialAd disableMoatLimiting];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: Interstitial Ad %ld - Event %ld", (long)placementId, (long)event);
        
        if (event == adLoaded) {
            [SAInterstitialAd play:placementId fromVC:self];
        }
    }];
    
    [SAVideoAd setConfigurationProduction];
    [SAVideoAd disableTestMode];
//    [SAVideoAd enableParentalGate];
    [SAVideoAd enableBumperPage];
    [SAVideoAd enableCloseButton];
    [SAVideoAd disableCloseAtEnd];
    [SAVideoAd disableMoatLimiting];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: Video Ad %ld - Event %ld", (long)placementId, (long)event);
        
        if (event == adLoaded) {
            [SAVideoAd play:placementId fromVC:self];
            [SAVideoAd play:placementId fromVC:self];
        }
    }];
    
    _data = [@[
                @{
                  @"name": @"Banners",
                  @"items": @[
                          @{@"name": @"CPM Banner 1 (Image)",
                            @"pid": @(636)},
                          @{@"name": @"CPM Banner 2 (Image)",
                            @"pid": @(635)},
                          @{@"name": @"CPI Banner 1 (Image)",
                            @"pid": @(618)},
                          @{@"name": @"CPM MPU 1 (Tag)",
                            @"pid": @(619)}
                          ]
                  },
                @{
                    @"name": @"Interstitials",
                    @"items": @[
                            @{@"name": @"CPM Interstitial 1 (Image)",
                              @"pid": @(34052)},
                            @{@"name": @"CPM Interstitial 2 (Rich Media)",
                              @"pid": @(621)},
                            @{@"name": @"CPM Interstitial 3 (Rich Media)",
                              @"pid": @(622)},
                            @{@"name": @"CPM Interstitial 4 (Rich Media)",
                              @"pid": @(637)},
                            @{@"name": @"CPM Interstitial 5 (Rich Media)",
                              @"pid": @(624)},
                            @{@"name": @"CPM Interstitial 6 (Rich Media)",
                              @"pid": @(625)},
                            @{@"name": @"CPM Interstitial 7 (Scalable Rich Media)",
                              @"pid": @(643)},
                            @{@"name": @"CPM Interstitial 8 (Scrollable Rich Media)",
                              @"pid": @(653)},
                            @{@"name": @"CPM Interstitial 9 (Tag)",
                              @"pid": @(626)},
                            @{@"name": @"CPM Interstitial 10 (Rafa)",
                              @"pid": @(657)},
                            @{@"name": @"Sing Interstitial",
                              @"pid": @(659)},
                            @{@"name": @"400 Interstitial",
                              @"pid": @(702)},
                            @{@"name": @"Rich Media Video",
                              @"pid": @(715)},
                            @{@"name": @"Rich Media Video",
                              @"pid": @(33615)}
                            ]
                  },
                @{
                    @"name": @"Videos",
                    @"items": @[
                            @{@"name": @"CPM Preroll 1 (Video)",
                              @"pid": @(36454)}
                            ]
                  }
              ] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [_data count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *item = [_data objectAtIndex:section];
    return [item objectForKey:@"name"];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *item = [_data objectAtIndex:section];
    NSArray *items = [item objectForKey:@"items"];
    return [items count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyId"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyId"];
    }
    
    NSDictionary *item = [_data objectAtIndex:[indexPath section]];
    NSArray *items = [item objectForKey:@"items"];
    NSDictionary *placement = [items objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld | %@",
                           (long)[[placement objectForKey:@"pid"] integerValue],
                           [placement objectForKey:@"name"]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [_data objectAtIndex:[indexPath section]];
    NSArray *items = [item objectForKey:@"items"];
    NSDictionary *placement = [items objectAtIndex:[indexPath row]];
    
    NSInteger placementId = [[placement objectForKey:@"pid"] integerValue];
    
    // BANNERS
    if ([indexPath section] == 0) {
        
        [_bannerAd load:placementId];
        
    }
    // INTERSTITIALS
    else if ([indexPath section] == 1) {
        
        [SAInterstitialAd load:placementId];
        
    }
    // VIDEOS
    else if ([indexPath section] == 2) {
        
        [SAVideoAd load:placementId];
        
    }
}



@end
