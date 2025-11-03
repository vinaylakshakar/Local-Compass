//
//  AppDelegate.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-08-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//
// vinay changes
//rajat

#import "AppDelegate.h"
//#import <Stripe/Stripe.h>
#import "Reachability.h"
#import "Constants.h"
#import "DashboardViewController.h"
#import "UpdateSocialInfoViewController.h"
#import "OnboardingViewController.h"
#import "SocialLoginViewController.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()
{
    Reachability *networkReachability;
    NetworkStatus networkStatus;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self maintainLoginUser];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //***Stripe***//
   // [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:@"pk_test_N2xj0M5AF9QrP4YNjr03BvhN"];
    //***Set Apple Pay(optional)***//
    //[[STPPaymentConfiguration sharedConfiguration] setAppleMerchantIdentifier:@"your apple merchant identifier"];
    
    //****FACEBOOK****//
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //****GOOGLE****//
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [[GIDSignIn sharedInstance] signOut];
    [GIDSignIn sharedInstance].delegate = self;
     [self registerForRemoteNotifications];
    return YES;
}
-(void)maintainLoginUser
{
 
    SocialLoginViewController *socialLogin = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SocialLoginViewController"];
    
    
    
        if ([USERDEFAULTS valueForKey:LoginfromSocial])
        {

            if ([[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"phone_no"] isEqualToString:@""] || [[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"zipcode"] isEqualToString:@""])
            {
                
                UpdateSocialInfoViewController *updateSocialInfo =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpdateSocialInfoViewController"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:socialLogin];
                self.window.rootViewController = navController;
                [navController pushViewController:updateSocialInfo animated:NO];
            } else
            {
                DashboardViewController *dashBoard = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:socialLogin];
                self.window.rootViewController = navController;
                [navController pushViewController:dashBoard animated:NO];
            }
            
            
        } else {
            
            
            if ([USERDEFAULTS valueForKey:DictUserData] && [[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"is_first_login"] isEqualToString:@"0"])
            {
                DashboardViewController *Dashboard = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DashboardViewController"]; //or the homeController
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:socialLogin];
                self.window.rootViewController = navController;
                 [navController pushViewController:Dashboard animated:NO];
            }
            else if ([USERDEFAULTS valueForKey:DictUserData] && [[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"is_first_login"] isEqualToString:@"1"])
            {
                OnboardingViewController *onboarding =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:socialLogin];
                self.window.rootViewController = navController;
                [navController pushViewController:onboarding animated:NO];
            }
         
        }

}

   
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SLogin"] isEqualToString:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                          openURL:url
                                                                sourceApplication:sourceApplication
                                                                       annotation:annotation];
    }
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
   
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    
//    [userinfo setValue:idToken forKey:@"idToken"];
//    [userinfo setValue:email forKey:@"email"];
    
    
    if (idToken) {
        
        NSMutableDictionary *userinfo = [[NSMutableDictionary alloc]init];
        [userinfo setObject:userId forKey:@"idToken"];
        [userinfo setObject:email forKey:@"email"];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"googleLoginNotification" object:self userInfo:userinfo];
    }
   
    // ...
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSUserDefaults standardUserDefaults]setValue:token forKey:deviceId];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
                
                //LOCAL NOTIFICATION
                //
                //                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                //                    if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
                //                        // Notifications not allowed
                //                    }
                //                }];
                
                
                
            }
        }];
    }
    else {
        // Code for old versions
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
        
        
    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{

    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
        
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }

   
//    if ([[[notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"]  rangeOfString:@"Property Deleted"].location == NSNotFound) {
//
//        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
//
//    }    
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"ALERT !!!"
                                 
                                 message:[NSString stringWithFormat:@"Failed to get token, error: %@", error]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * yesButton = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     //Handle your yes please button action here
                                     
                                     
                                     
                                 }];
    
    [alert addAction:yesButton];
    
   // [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
}

//progressHUD

-(void)showProgressHUD
{
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No NetWork Connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else
    {
        [self createProgressHud];
        [self.window bringSubviewToFront:_progressHUD];
        [_progressHUD show:YES];
        
    }
}

-(void)showProgressHUDInView:(UIView *)view
{
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No NetWork Connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else
    {
        [self createProgressHud];
        [view bringSubviewToFront:_progressHUD];
        [_progressHUD show:YES];
        
    }
}


//Hide Progress HUD
-(void)hideProgressHUD
{
    [_progressHUD hide:YES];
}
//Create Progress HUD
-(void)createProgressHud
{
    if(_progressHUD)
    {
        return;
    }
    else
    {
        _progressHUD=[[MBProgressHUD alloc]initWithWindow:self.window];
        _progressHUD.labelText = @"Loading...";
        [self.window addSubview:_progressHUD];
    }
}


@end
