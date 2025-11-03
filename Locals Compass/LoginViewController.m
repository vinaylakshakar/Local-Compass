 //
//  LoginViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-18.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "LoginViewController.h"
#import "OnboardingViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "DashboardViewController.h"

@interface LoginViewController ()
{
  UIVisualEffectView *visualEffectView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets= NO;
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.view.bounds;
    
    [visualEffectView.contentView addSubview:self.errorView];
    [self setLayout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setLayout
{
    self.errorView.layer.cornerRadius = 5;
    self.errorView.layer.masksToBounds = true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okErrorAction:(id)sender {
    
    [visualEffectView removeFromSuperview];
    [self.errorView setHidden:YES];
  
}


- (BOOL) validateEmail:(NSString *) email

{
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

-(void)loginUser
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject: _emailField.text forKey:@"email"];
    [dict setObject: self.passwordField.text forKey:@"password"];
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"user_device_id"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"user_device_id"];
        
    }
    [dict setObject:@"ios" forKey:@"user_device_type"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]loginUser:^(id object)
     {
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             //NSMutableDictionary *userdata = [[object valueForKey:@"data"] mutableCopy];
             [USERDEFAULTS removeObjectForKey:LoginfromSocial];
             [USERDEFAULTS setObject:[object valueForKey:@"data"] forKey:DictUserData];
             [USERDEFAULTS setObject:[[object valueForKey:@"data"] valueForKey:@"no_of_unread_messages"] forKey:UnreadMessages];
             
             if ([[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"is_first_login"] isEqualToString:@"0"])
             {
                 DashboardViewController *dashBoard = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                 [self.navigationController pushViewController:dashBoard animated:YES];
             } else
             {
                 OnboardingViewController *onboarding =[self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
                 [self.navigationController pushViewController:onboarding animated:YES];
             }
             

             
             
             
         } else
         {
             [self.loginFailLable setText:[NSString stringWithFormat:@"We could't find \"%@\" Please use email address associated with your Locals Compass account.",_emailField.text]];
             [self.view addSubview:visualEffectView];
             [self.errorView setHidden:NO];
             
         }
         
          [kAppDelegate hideProgressHUD];
         
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

- (IBAction)loginBtnAction:(id)sender {
    
    if ([[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please enter All Fields."   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (![self validateEmail:_emailField.text])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please enter Valid Email"   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        [self loginUser];

    }
    
    
   
}
- (IBAction)backbtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
