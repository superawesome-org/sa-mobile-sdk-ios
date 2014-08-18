//
//  ViewController.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 01/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "ViewController.h"
#import "SATokenResponse.h"
#import "NSString+URLEncode.h"


@interface ViewController ()

@property (nonatomic,strong) SAInterstitialView *interstitial;

@end

@implementation ViewController

- (void)fetchToken:(NSString*)token {
    NSString *url = [NSString stringWithFormat:@"http://172.16.0.3/jsonp/app/superawesomegames/%@/token", [token urlencode]];
    NSURL *jokesUrl = [NSURL URLWithString:url];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:jokesUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        SATokenResponse *resp = [[SATokenResponse alloc] initWithData:data error:&error];
    }] resume];
}

- (IBAction)openLogin:(id)sender
{
    SALoginViewController *vc = [[SALoginViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)presentInterstitionalAd:(id)sender
{
    [self.interstitial present];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.interstitial = [[SAInterstitialView alloc] initWithViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SALoginViewControllerDelegate

- (void)loginViewController:(SALoginViewController *)loginVC didSucceedWithToken:(NSString *)token
{
    NSLog(@"Login success! Token: %@", token);
    [self fetchToken: token];
}

- (void)loginViewController:(SALoginViewController *)loginVC didFailWithError:(NSString *)error
{
    NSLog(@"Login failed! Error: %@", error);
}

@end
