//
//  ViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-08-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialLogin.h"
#import <Google/SignIn.h>
#import "Globals.h"

@interface ViewController : UIViewController <GIDSignInUIDelegate>

@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end

