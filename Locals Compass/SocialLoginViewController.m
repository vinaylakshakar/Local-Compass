//
//  SocialLoginViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-18.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "SocialLoginViewController.h"
#import "TermsViewController.h"
#import "OnboardingViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UpdateSocialInfoViewController.h"
#import "DashboardViewController.h"

@interface SocialLoginViewController ()
{
    
    NSMutableDictionary *Socialdict;
}

@end

@implementation SocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"By signing up I agree to the Terms of Service"]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.16 green:0.69 blue:0.88 alpha:1.0] range:NSMakeRange(0,45 )];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 29)];
    [_termsConditionBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"fbLoginNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"googleLoginNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"fbLoginNotification"]) {
        //NSDictionary *myDictionary = (NSDictionary *)notification.object;
        //doSomething here.
        NSDictionary* userInfo = notification.userInfo;
         Socialdict = [[NSMutableDictionary alloc]init];
        [Socialdict setObject:[userInfo objectForKey:@"id"] forKey:@"fb_id"];
        [Socialdict setObject:@"facebook" forKey:@"login_type"];
        if ([userInfo objectForKey:@"email"]) {
             [Socialdict setObject:[userInfo objectForKey:@"email"] forKey:@"email"];
        } else {
             [Socialdict setObject:@"" forKey:@"email"];
        }
        
        [self loginUser];
       
    }
    if ([[notification name] isEqualToString:@"googleLoginNotification"]) {
        // NSDictionary *myDictionary = (NSDictionary *)notification.object;
        //doSomething here.
        NSDictionary* userInfo = notification.userInfo;
         Socialdict = [[NSMutableDictionary alloc]init];
        [Socialdict setObject:[userInfo objectForKey:@"idToken"] forKey:@"google_id"];
        [Socialdict setObject:@"google" forKey:@"login_type"];
        [Socialdict setObject:[userInfo objectForKey:@"email"] forKey:@"email"];
        [self loginUser];
    }
}


-(void)loginUser
{
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [Socialdict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"user_device_id"];
        
    }
    else{
        [Socialdict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"user_device_id"];
        
    }
    [Socialdict setObject:@"ios" forKey:@"user_device_type"];
    
    NSLog(@"%@",Socialdict);
    
    [[NetworkEngine sharedNetworkEngine]loginUser:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 NSMutableDictionary *userdata = [[object valueForKey:@"data"] mutableCopy];
                 [USERDEFAULTS setObject:userdata forKey:DictUserData];
                 [USERDEFAULTS setObject:@"yes" forKey:LoginfromSocial];
                 [USERDEFAULTS setObject:[userdata valueForKey:@"no_of_unread_messages"] forKey:UnreadMessages];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [kAppDelegate hideProgressHUD];
                     
                     
                     
                     if ([[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"phone_no"] isEqualToString:@""] || [[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"zipcode"] isEqualToString:@""])
                     {
                         
                         UpdateSocialInfoViewController *updateSocialInfo =[self.storyboard instantiateViewControllerWithIdentifier:@"UpdateSocialInfoViewController"];
                         [self.navigationController pushViewController:updateSocialInfo animated:YES];
                     } else
                     {
                         DashboardViewController *dashBoard = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                         [self.navigationController pushViewController:dashBoard animated:YES];
                     }
                 });
             });

        

             
             
         } else
         {
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:nil
                                          
                                          message:[object valueForKey:@"Message"]
                                          preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
             
             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];
             
         }
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:Socialdict];
}


- (IBAction)termsConditionAction:(id)sender {
    
    TermsViewController *terms =[self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    [self.navigationController pushViewController:terms animated:YES];
    
}

- (IBAction)googleLoginBtn:(id)sender {
    
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)facebookLoginBtn:(id)sender {
    
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
