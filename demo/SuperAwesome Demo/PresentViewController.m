//
//  PresentViewController.m
//  sa-mobileios-sdk-test
//
//  Created by Gabriel Coman on 09/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "PresentViewController.h"
#import "SuperAwesome.h"

@interface PresentViewController ()

@property (nonatomic, strong) UIButton *back;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"THIS ONE");
    self.view.backgroundColor = [UIColor whiteColor];
    
    _back = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 70, 30)];
    [_back setTitle:@"Back" forState:UIControlStateNormal];
    [_back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) goBack {
    [self dismissViewControllerAnimated:YES completion:^{
        //
        for (UIView *v in self.view.subviews) {
            if ([v isKindOfClass:[SAVideoAd class]]) {
                [(SAVideoAd*)v stopVideoAd];
            }
        }
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
