//
//  SocialLogin.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-08-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "SocialLogin.h"

@implementation SocialLogin {
    
    UIViewController *currentView;
}
    
+ (instancetype)Shared {

    static SocialLogin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SocialLogin alloc] init];
        
    });
    return sharedInstance;
}
    
- (void)FBLogin {
    
    currentView = [WINDOW rootViewController];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithReadPermissions:@[@"email"] fromViewController:currentView handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            
        }
        else if (result.isCancelled) {
            
        }
        else {
            
            [self getFacebookProfileInfos];
        }
        
    }];
}

-(void)getFacebookProfileInfos {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if(result)
             {
                 if ([result objectForKey:@"email"]) {
                     NSLog(@"User id : %@",[result objectForKey:@"email"]);
                 }
                 if ([result objectForKey:@"name"]) {
                     NSLog(@"First Name : %@",[result objectForKey:@"name"]);
                 }
                 if ([result objectForKey:@"id"]) {
                     NSLog(@"User id : %@",[result objectForKey:@"id"]);
                 }
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"fbLoginNotification" object:self userInfo:result];
             }
         }];
    }
    
}
    
@end
