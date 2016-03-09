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

@property (nonatomic,assign) NSInteger number1;
@property (nonatomic,assign) NSInteger number2;
@property (nonatomic,assign) NSInteger solution;

@property (nonatomic, retain) UIAlertView *challengeAlertView;
@property (nonatomic, retain) UIAlertController *challangeAlertController;
@property (nonatomic, retain) UIAlertView *wrongAnswerAlertView;

// the ad response
@property (nonatomic, retain) SAAd *ad;

// weak ref to view
@property (nonatomic, weak) UIView *weakAdView;

@end

@implementation SAParentalGate

// custom init functions
- (id) initWithWeakRefToView:(UIView *)weakRef {
    if (self = [super init]) {
        _weakAdView = weakRef;
        if ([_weakAdView isKindOfClass:[SABannerAd class]]) {
            _ad = [(SABannerAd*)_weakAdView getAd];
        }
        if ([_weakAdView isKindOfClass:[SAVideoAd class]]){
            _ad = [(SAVideoAd*)_weakAdView getAd];
        }
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
    
    if (NSClassFromString(@"UIAlertController")) {
        [self showWithAlertController];
    } else {
        [self showWithUIAlertView];
    }
}

#pragma mark iOS 8.0 +

- (void) showWithAlertController {
    // action block #1
    actionBlock cancelBlock = ^(UIAlertAction *action) {
        // calls to delegate or blocks
        if(_delegate && [_delegate respondsToSelector:@selector(parentalGateWasCanceled:)]){
            [_delegate parentalGateWasCanceled:_ad.placementId];
        }
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
    if (buttonIndex == 1) {
        UITextField *textField = [_challengeAlertView textFieldAtIndex:0];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *input = [f numberFromString:textField.text];
        
        if ([input integerValue] == _solution) {
            [self handlePGSuccess];
        } else {
            [self handlePGError];
        }
    }
}

#pragma mark General Functions

- (void) handlePGSuccess {
    // call to delegate
    if(_delegate && [_delegate respondsToSelector:@selector(parentalGateWasSucceded:)]){
        [_delegate parentalGateWasSucceded:_ad.placementId];
    }
    
    // finally advance to URL
    if ([_weakAdView respondsToSelector:@selector(advanceToClick)]) {
        if ([_weakAdView isKindOfClass:[SABannerAd class]]) {
            [(SABannerAd*)_weakAdView advanceToClick];
        }
        if ([_weakAdView isKindOfClass:[SAVideoAd class]]){
            [(SAVideoAd*)_weakAdView advanceToClick];
        }
    }
}

- (void) handlePGError {
    // ERROR
    _wrongAnswerAlertView = [[UIAlertView alloc] initWithTitle:SA_ERROR_ALERTVIEW_TITLE
                                                       message:SA_ERROR_ALERTVIEW_MESSAGE
                                                      delegate:nil
                                             cancelButtonTitle:SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE
                                             otherButtonTitles:nil];
    _wrongAnswerAlertView.alertViewStyle = UIAlertViewStyleDefault;
    [_wrongAnswerAlertView show];
    
    // call to delegate
    if(_delegate && [_delegate respondsToSelector:@selector(parentalGateWasFailed:)]){
        [_delegate parentalGateWasFailed:_ad.placementId];
    }
}

@end
