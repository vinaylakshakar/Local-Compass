//
//  LoginViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-18.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *errorView;
- (IBAction)okErrorAction:(id)sender;
- (IBAction)loginBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)backbtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginFailLable;

@end
