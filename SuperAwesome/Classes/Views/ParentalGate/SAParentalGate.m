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
#import "SASender.h"

// import views
#import "SAView.h"

// aux stuff
#import "UIAlertController+Window.h"
#import "SAAux.h"

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
@property (nonatomic, retain) UIAlertController *challangeAlertView;
@property (nonatomic, retain) UIAlertView *wrongAnswerAlertView;

// blocks (if you don't want to use protocols
@property (nonatomic, retain) NSString *adname;
@property (nonatomic, assign) interactionBlock didGetThroughParentalGate;
@property (nonatomic, assign) interactionBlock didCancelParentalGate;
@property (nonatomic, assign) interactionBlock didFailChallengeForParentalGate;

// the ad response
@property (nonatomic, retain) SAAd *ad;

// weak ref to view
@property (nonatomic, weak) SAView *weakAdView;

@end

@implementation SAParentalGate

// custom init functions
- (id) initWithWeakRefToView:(SAView *)weakRef {
    if (self = [super init]) {
        _weakAdView = weakRef;
        _ad = [_weakAdView ad];
    }
    
    return self;
}

- (id) initWithPlacementId:(NSInteger)placementId
             andCreativeId:(NSInteger)creativeId
             andLineItemId:(NSInteger)lineItemId {
    if (self = [super init]) {
        // form the ad from bits and pieces
        _ad = [[SAAd alloc] init];
        _ad.creative = [[SACreative alloc] init];
        _ad.placementId = placementId;
        _ad.lineItemId = lineItemId;
        _ad.creative.creativeId = creativeId;
    }
    
    return self;
}

// init a new question
- (void) newQuestion {
    _number1 = [SAAux randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _number2 = [SAAux randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _solution = _number1 + _number2;
}

- (void) show {
    [self newQuestion];
    
    // action block #1
    actionBlock cancelBlock = ^(UIAlertAction *action) {
        // calls to delegate or blocks
#pragma mark Normal iOS behaviour
        if(self.delegate && [self.delegate respondsToSelector:@selector(parentalGateWasCanceled:)]){
            [self.delegate parentalGateWasCanceled:_ad.placementId];
        }
        
#pragma mark Unity / iOS behaviour
        if (_didCancelParentalGate != nil) {
            _didCancelParentalGate(_adname);
        }
    };
    
    // action block #2
    actionBlock continueBlock = ^(UIAlertAction *action) {
        
        // get number from text field
        UITextField *textField = [[_challangeAlertView textFields] firstObject];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *input = [f numberFromString:textField.text];
        
        // what happens when you get a right solution
        if([input integerValue] == self.solution){
            
            // call to delegate
#pragma mark Normal iOS behaviour
            if(self.delegate && [self.delegate respondsToSelector:@selector(parentalGateWasSucceded:)]){
                [self.delegate parentalGateWasSucceded:_ad.placementId];
            }
            
#pragma mark Unity / iOS behaviour
            if (_didGetThroughParentalGate != nil){
                _didGetThroughParentalGate(_adname);
            }
            
            // finally advance to URL
            [_weakAdView advanceToClick];
        }
        // or a bad solution
        else{
            // ERROR
            _wrongAnswerAlertView = [[UIAlertView alloc] initWithTitle:SA_ERROR_ALERTVIEW_TITLE
                                                               message:SA_ERROR_ALERTVIEW_MESSAGE
                                                              delegate:self
                                                     cancelButtonTitle:SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE
                                                     otherButtonTitles: nil];
            [_wrongAnswerAlertView show];
            
            // call to delegate
#pragma mark Normal iOS behaviour
            if(self.delegate && [self.delegate respondsToSelector:@selector(parentalGateWasFailed:)]){
                [self.delegate parentalGateWasFailed:_ad.placementId];
            }
            
#pragma mark Unity / iOS behaviour
            if (_didFailChallengeForParentalGate != nil){
                _didFailChallengeForParentalGate(_adname);
            }
        }
    };
    
    
    // alert view (controller)
    _challangeAlertView = [UIAlertController alertControllerWithTitle:SA_CHALLANGE_ALERTVIEW_TITLE
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
    [_challangeAlertView addAction:cancelBtn];
    [_challangeAlertView addAction:continueBtn];
    __block UITextField *localTextField;
    
    [_challangeAlertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
        localTextField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [_challangeAlertView show];
}

- (void) setAdName:(NSString *)adname {
    _adname = adname;
}

- (void) addSuccessBlock:(interactionBlock)block {
    _didGetThroughParentalGate = block;
}

- (void) addErrorBlock:(interactionBlock)block {
    _didFailChallengeForParentalGate = block;
}

- (void) addCancelBlock:(interactionBlock)block {
    _didCancelParentalGate = block;
}

@end
