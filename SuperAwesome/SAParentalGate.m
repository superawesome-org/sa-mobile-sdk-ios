//
//  ParentalGate.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 16/09/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SAParentalGate.h"

@interface SAParentalGate ()

@property (nonatomic,assign) NSInteger number1;
@property (nonatomic,assign) NSInteger number2;
@property (nonatomic,assign) NSInteger solution;
@property (nonatomic,strong) UIAlertView *challengeAlertView;
@property (nonatomic,strong) UIAlertView *wrongAnswerAlertView;

@end

@implementation SAParentalGate

- (void)newQuestion
{
    self.number1 = arc4random() % 80 + 20;
    self.number2 = arc4random() % 80 + 20;
    self.solution = self.number1 + self.number2;
}

- (void)show
{
    [self newQuestion];
    NSString *msg = [NSString stringWithFormat:@"Solve the following problem to continue:\n%@ + %@ = ?", @(self.number1), @(self.number2)];
    self.challengeAlertView = [[UIAlertView alloc] initWithTitle:@"Parental Gate" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    self.challengeAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [self.challengeAlertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.challengeAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.challengeAlertView){
        if(buttonIndex == 0){
            if(self.delegate && [self.delegate respondsToSelector:@selector(didCancelParentalGate:)]){
                [self.delegate didCancelParentalGate:self];
            }
        }else if(buttonIndex == 1){
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *input = [f numberFromString:textField.text];
            if([input integerValue] == self.solution){
                if(self.delegate && [self.delegate respondsToSelector:@selector(didGetThroughParentalGate:)]){
                    [self.delegate didGetThroughParentalGate:self];
                }
            }else{
                self.wrongAnswerAlertView = [[UIAlertView alloc] initWithTitle:@"Sorry, that was the wrong answer" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [self.wrongAnswerAlertView show];
                [self performSelector:@selector(dismissAlertView:) withObject:self.wrongAnswerAlertView afterDelay:2];
            }
        }
    }else if(alertView == self.wrongAnswerAlertView){
        [self dismissAlertView:self.wrongAnswerAlertView];
    }
}

- (void)dismissAlertView:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailChallengeForParentalGate:)]){
        [self.delegate didFailChallengeForParentalGate:self];
    }
}

@end
