//
//  ViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-08-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
}

- (IBAction)btn_FbLogin:(id)sender {
    
    [[SocialLogin Shared] FBLogin];
    [[NSUserDefaults standardUserDefaults] setValue:@"fb" forKey:@"SLogin"];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"google" forKey:@"SLogin"];
    
}
    
    // Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}
    
    // Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
