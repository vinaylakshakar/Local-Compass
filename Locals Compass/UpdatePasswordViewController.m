//
//  UpdatePasswordViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-02.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updatePassword
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    [dict setObject:self.oldPasswordField.text forKey:@"oldPassword"];
    [dict setObject:self.passwordField.text forKey:@"newPassword"];
   
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }

    
    [[NetworkEngine sharedNetworkEngine]updatePassword:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             [self.navigationController popViewControllerAnimated:YES];
             
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
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                                    onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

- (IBAction)updateBtnAction:(id)sender {
    
    if ([[self.oldPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.reTypePasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please enter All Fields"   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (![self.passwordField.text isEqualToString:self.reTypePasswordField.text])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Your password and Re-enter Password password should be same"   preferredStyle:UIAlertControllerStyleAlert];
        
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
        [self updatePassword];
        
    }
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
