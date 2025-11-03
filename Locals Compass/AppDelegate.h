//
//  AppDelegate.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-08-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <UserNotifications/UserNotifications.h>
#import <Google/SignIn.h>
#import "MBProgressHUD.h"
#import "Globals.h"
#import "LoginNavigationController.h"
#import "DashboardNavigationController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate, GIDSignInUIDelegate,UNUserNotificationCenterDelegate>
{
    MBProgressHUD *_progressHUD;
 
}

@property (strong, nonatomic) UIWindow *window;
- (void)showProgressHUD;
- (void)hideProgressHUD;
-(void)showProgressHUDInView:(UIView *)view;


@end

