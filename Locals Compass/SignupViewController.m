//
//  SignupViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-19.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "SignupViewController.h"
#import "TermsViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "NetworkEngine.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface SignupViewController ()
{
    UIDatePicker *picker ;
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"By Signing up i agree the Terms of Service"]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.16 green:0.69 blue:0.88 alpha:1.0] range:NSMakeRange(0,42 )];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 25)];
    [_termsConditionsBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [self setlayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setlayout
{
    UIDatePicker *datepicker =[[UIDatePicker alloc]init];
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    [self.dateOfBirthField setInputView:datepicker];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
    // NSString *date = [dateFormat stringFromDate:datePicker.date];
    
    self.dateOfBirthField.text = [dateFormat stringFromDate:datepicker.date];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, self.signupView.frame.size.height)];
    
}

-(void)updateTextField:(id)sender
{
    picker = (UIDatePicker*)self.dateOfBirthField.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
    // NSString *date = [dateFormat stringFromDate:datePicker.date];
    
    self.dateOfBirthField.text = [dateFormat stringFromDate:picker.date];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)termsConditionAction:(id)sender {
    
    TermsViewController *terms =[self.storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    [self.navigationController pushViewController:terms animated:YES];
}

- (IBAction)loginBtnAction:(id)sender {
    
    //    LoginViewController *login =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    //    [self.navigationController pushViewController:login animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) validateEmail:(NSString *) email

{
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

-(void) signedUpSuccess{
    
    //    http://localscompass.silappdevops.com/services/signup.php?firstname=test&lastname=testlast&email=tester444@silstonegroup.com&password=123456&user_device_id=1&user_device_type=123456&username=test444&date_of_birth=1997-11-30
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.firstNameField.text forKey:@"firstname"];
    [dict setObject:self.lastNameField.text forKey:@"lastname"];
    [dict setObject:self.emailField.text forKey:@"email"];
    [dict setObject:self.passwordField.text forKey:@"password"];
    [dict setObject:self.dateOfBirthField.text forKey:@"date_of_birth"];
    [dict setObject:self.userNameField.text forKey:@"username"];
    [dict setObject:@"iOS" forKey:@"user_device_type"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"user_device_id"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"user_device_id"];
        
    }
    
    NSLog(@"dict: %@", dict);
    
    [[NetworkEngine sharedNetworkEngine]signup:^(id object)
     {
         NSLog(@"%@",object);
         
         NSString *respose = [object valueForKey:@"Response"];
         if ([respose isEqualToString:@"Success"])
         {
             [kAppDelegate hideProgressHUD];
             [USERDEFAULTS setObject:[object valueForKey:@"Data"] forKey:DictUserData];
             RegistrationViewController *registration =[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
             [self.navigationController pushViewController:registration animated:YES];
             
         }
         else
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

- (IBAction)signupBtnAction:(id)sender
{
    
    if ([[self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.reEnterPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.dateOfBirthField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
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
    }
    else if (![self.passwordField.text isEqualToString:self.reEnterPasswordField.text])
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
    }
    else if ([picker.date compare:[NSDate date]] == NSOrderedDescending)
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Your birthdate is incorrect!"   preferredStyle:UIAlertControllerStyleAlert];
        
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
       //NSLog(@"success");
        [self signedUpSuccess];
    }
    
    
}


@end

