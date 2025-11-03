//
//  SignupViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-19.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *termsConditionsBtn;
- (IBAction)termsConditionAction:(id)sender;
- (IBAction)loginBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthField;
- (IBAction)signupBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIView *signupView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
