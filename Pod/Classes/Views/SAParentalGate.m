//
//  SAParentalGate2.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import main header
#import "SAParentalGate.h"

// import needed modelspace
#import "SAAd.h"
#import "SACreative.h"

// import other headers
#import "SuperAwesome.h"

// import views
#import "SABannerAd.h"
#import "SAVideoAd.h"

// aux stuff
#import "SAExtensions.h"
#import "SAUtils.h"
#import "SAEvents.h"

// parental gate defines
#define SA_CHALLANGE_ALERTVIEW 0
#define SA_ERROR_ALLERTVIEW 1

#define SA_RAND_MIN 50
#define SA_RAND_MAX 99

#define SA_CHALLANGE_ALERTVIEW_TITLE @"Parental Gate"
#define SA_CHALLANGE_ALERTVIEW_MESSAGE @"Please solve the following problem to continue:\n%@ + %@ = ?"
#define SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE [NSString stringWithFormat:SA_CHALLANGE_ALERTVIEW_MESSAGE, @(_number1), @(_number2)]
#define SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE @"Cancel"
#define SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE @"Continue"

#define SA_ERROR_ALERTVIEW_TITLE @"Oops! That was the wrong answer."
#define SA_ERROR_ALERTVIEW_MESSAGE @"Please seek guidance from a responsible adult to help you continue."
#define SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE @"Ok"

// anonymous extension of SAParentalGate
@interface SAParentalGate ()

@property (nonatomic, strong) SAEvents *events;

@property (nonatomic,assign) NSInteger number1;
@property (nonatomic,assign) NSInteger number2;
@property (nonatomic,assign) NSInteger solution;

@property (nonatomic, retain) UIAlertView *challengeAlertView;
@property (nonatomic, retain) UIAlertController *challangeAlertController;
@property (nonatomic, retain) UIAlertView *wrongAnswerAlertView;

// the ad response
@property (nonatomic, retain) SAAd *ad;

// weak ref to view
@property (nonatomic, weak) id weakAdView;

@end

@implementation SAParentalGate

// custom init functions
- (id) initWithWeakRefToView:(id)weakRef {
    if (self = [super init]) {
        _weakAdView = weakRef;
        
        // get ad
        NSValue *adVal = [SAUtils invoke:@"getAd" onTarget:_weakAdView];
        if (adVal) {
            [adVal getValue:&_ad];
        }
        
        _events = [[SAEvents alloc] init];
        [_events setAd:_ad];
    }
    
    return self;
}

// init a new question
- (void) newQuestion {
    _number1 = [SAUtils randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _number2 = [SAUtils randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _solution = _number1 + _number2;
}

- (void) show {
    [self newQuestion];
    
    // send event
    [_events sendAllEventsForKey:@"pg_open"];
    
    // pause video
    [SAUtils invoke:@"pause" onTarget:_weakAdView];
    
    if (NSClassFromString(@"UIAlertController")) {
        [self showWithAlertController];
    } else {
        [self showWithUIAlertView];
    }
}

- (void) close {
    
    if (NSClassFromString(@"UIAlertController")) {
        [_challangeAlertController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [_challengeAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark iOS 8.0 +

- (void) showWithAlertController {
    // action block #1
    actionBlock cancelBlock = ^(UIAlertAction *action) {
        
        // send event
        [_events sendAllEventsForKey:@"pg_close"];
        
        // resume video
        [SAUtils invoke:@"resume" onTarget:_weakAdView];
    };
    
    // action block #2
    actionBlock continueBlock = ^(UIAlertAction *action) {
        
        // get number from text field
        UITextField *textField = [[_challangeAlertController textFields] firstObject];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *input = [f numberFromString:textField.text];
        [textField resignFirstResponder];
        
        // what happens when you get a right solution
        if([input integerValue] == self.solution){
            [self handlePGSuccess];
        }
        // or a bad solution
        else{
            
            // resume video
            [SAUtils invoke:@"resume" onTarget:_weakAdView];
            
            [self handlePGError];
        }
    };
    
    
    // alert view (controller)
    _challangeAlertController = [UIAlertController alertControllerWithTitle:SA_CHALLANGE_ALERTVIEW_TITLE
                                                                    message:SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    // actions
    UIAlertAction* continueBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE
                                                          style:UIAlertActionStyleDefault
                                                        handler:continueBlock];
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE
                                                        style:UIAlertActionStyleDefault
                                                      handler:cancelBlock];
    
    
    // add actions
    [_challangeAlertController addAction:cancelBtn];
    [_challangeAlertController addAction:continueBtn];
    __block UITextField *localTextField;
    
    [_challangeAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
        localTextField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [_challangeAlertController show];
}

#pragma mark iOS 8.0 -

- (void) showWithUIAlertView {
    _challengeAlertView = [[UIAlertView alloc] initWithTitle:SA_CHALLANGE_ALERTVIEW_TITLE
                                                                 message:SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE
                                                                delegate:self
                                                       cancelButtonTitle:SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE
                                                       otherButtonTitles:SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE, nil];
    _challengeAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_challengeAlertView show];
}

- (void) willPresentAlertView:(UIAlertView *)alertView {
    UITextField *textField = [_challengeAlertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // continue
    if (buttonIndex == 1) {
        UITextField *textField = [_challengeAlertView textFieldAtIndex:0];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *input = [f numberFromString:textField.text];
        
        if ([input integerValue] == _solution) {
            [self handlePGSuccess];
        } else {
            
            // resume video
            [SAUtils invoke:@"resume" onTarget:_weakAdView];
            
            [self handlePGError];
        }
    }
    // cancel
    else if (buttonIndex == 0){
        // send event
        [_events sendAllEventsForKey:@"pg_close"];
        
        // resume video
        [SAUtils invoke:@"resume" onTarget:_weakAdView];
    }
}

#pragma mark General Functions

- (void) handlePGSuccess {
    
    // send data
    [_events sendAllEventsForKey:@"pg_success"];
    
    // finally advance to URL
    [SAUtils invoke:@"click" onTarget:_weakAdView];
}

- (void) handlePGError {
    
    // send data
    [_events sendAllEventsForKey:@"pg_fail"];
    
    // ERROR
    _wrongAnswerAlertView = [[UIAlertView alloc] initWithTitle:SA_ERROR_ALERTVIEW_TITLE
                                                       message:SA_ERROR_ALERTVIEW_MESSAGE
                                                      delegate:nil
                                             cancelButtonTitle:SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE
                                             otherButtonTitles:nil];
    _wrongAnswerAlertView.alertViewStyle = UIAlertViewStyleDefault;
    [_wrongAnswerAlertView show];
}

@end
