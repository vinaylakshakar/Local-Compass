//
//  SocialLoginViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-18.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialLogin.h"
#import <Google/SignIn.h>
#import "Globals.h"

@interface SocialLoginViewController : UIViewController<GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UIButton *termsConditionBtn;
- (IBAction)termsConditionAction:(id)sender;
- (IBAction)googleLoginBtn:(id)sender;
- (IBAction)facebookLoginBtn:(id)sender;

@end
