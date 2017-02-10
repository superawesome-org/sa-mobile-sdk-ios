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
#import "SAOnce.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SAOnce *once = [[SAOnce alloc] init];
    [once resetCPISent];
    
    SASession *session = [[SASession alloc] init];
    [session setConfigurationStaging];
    
    [[SACPI getInstance] sendInstallEvent:session
                               withTarget:[session getBundleId]
                              andResponse:^(BOOL success) {
                                  NSLog(@"CPI Operation is %d", success);
                              }];
    
    [_bannerAd setConfigurationStaging];
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
       
        NSLog(@"SUPER-AWESOME: Banner Ad %ld - Event %ld", placementId, event);
        
        if (event == adLoaded) {
            [_bannerAd play];
        }
        
    }];
    
    [SAInterstitialAd setConfigurationStaging];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: Interstitial Ad %ld - Event %ld", placementId, event);
        
        if (event == adLoaded) {
            [SAInterstitialAd play:placementId fromVC:self];
        }
    }];
    
    [SAVideoAd setConfigurationStaging];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: Video Ad %ld - Event %ld", placementId, event);
        
        if (event == adLoaded) {
            [SAVideoAd play:placementId fromVC:self];
        }
    }];
    
    [SAAppWall setConfigurationStaging];
    [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: AppWall Ad %ld - Event %ld", placementId, event);
        
        if (event == adLoaded) {
            [SAAppWall play:placementId fromVC:self];
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
                              @"pid": @(620)},
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
                            @{@"name": @"CPM Interstitial 7 (Tag)",
                              @"pid": @(626)}
                            ]
                  },
                @{
                    @"name": @"Videos",
                    @"items": @[
                            @{@"name": @"CPM Preroll 1 (Video)",
                              @"pid": @(628)},
                            @{@"name": @"CPM Preroll 2 (Video)",
                              @"pid": @(629)},
                            @{@"name": @"CPM Preroll 3 (Video)",
                              @"pid": @(630)},
                            @{@"name": @"CPM Preroll 4 (Tag)",
                              @"pid": @(631)},
                            @{@"name": @"CPI Preroll 1 (Video)",
                              @"pid": @(627)}
                            ]
                  },
                @{
                    @"name": @"App Wall",
                    @"items": @[
                            @{@"name": @"CPI AppWall 1 (Images)",
                              @"pid": @(633)}
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
    // APP WALL
    else if ([indexPath section] == 3) {
        
        [SAAppWall load:placementId];
        
    }
}



@end
