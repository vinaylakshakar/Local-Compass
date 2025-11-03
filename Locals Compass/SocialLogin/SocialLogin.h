//
//  SocialLogin.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-08-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Macros.h"
#import "Globals.h"

@interface SocialLogin : NSObject

+ (instancetype)Shared;
    
- (void)FBLogin;
    
@end
