//
//  PersonalinfoViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-02.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "PersonalinfoViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"

@interface PersonalinfoViewController ()
{
    UIDatePicker *picker;
}

@end

@implementation PersonalinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self.birthDateField setInputView:datepicker];

    
    NSString *dateString = [self.profileDict valueForKey:@"dob"];

    NSLog(@"%@", dateString);
    
    self.birthDateField.text = dateString;
    //
    self.firstNameField.text = [self.profileDict valueForKey:@"first_name"];
    self.lastNameField.text = [self.profileDict valueForKey:@"last_name"];
    self.emailField.text = [self.profileDict valueForKey:@"email"];
    self.contactNumberField.text = [self.profileDict valueForKey:@"phone_no"];
   // self.cityNameField.text = [self.profileDict valueForKey:@"phone_no"];
   
}

-(void)updateTextField:(id)sender
{
    picker = (UIDatePicker*)self.birthDateField.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
    // NSString *date = [dateFormat stringFromDate:datePicker.date];
    
    self.birthDateField.text = [dateFormat stringFromDate:picker.date];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField==_contactNumberField) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    return YES;
    
}

-(void)update_user_profile
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    [dict setObject:self.firstNameField.text forKey:@"firstName"];
    [dict setObject:self.lastNameField.text forKey:@"lastName"];
    [dict setObject:self.emailField.text forKey:@"email"];
    [dict setObject:self.contactNumberField.text forKey:@"phone"];
    [dict setObject:self.birthDateField.text forKey:@"dob"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"zipcode"] forKey:@"zipcode"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]update_user_profile:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             NSDictionary *userdata =  [[object valueForKey:@"Data"] objectAtIndex:0];
             [USERDEFAULTS setObject:userdata forKey:DictUserData];
             [USERDEFAULTS setObject:[userdata valueForKey:@"no_of_unread_messages"] forKey:UnreadMessages];
             [self.navigationController popViewControllerAnimated:YES];
             
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

- (BOOL) validateEmail:(NSString *) email

{
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateBtnAction:(id)sender {
    
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.birthDateField resignFirstResponder];
    [self.contactNumberField resignFirstResponder];
    [self.cityNameField resignFirstResponder];
    
    
    if ([[self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.birthDateField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.contactNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.cityNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
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
        [self update_user_profile];
 
    }
    
    
}
@end
