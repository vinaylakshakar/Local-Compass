//
//  UpdateSocialInfoViewController.m
//  Locals Compass
//
//  Created by Developer on 05/12/17.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "UpdateSocialInfoViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "DashboardViewController.h"

@interface UpdateSocialInfoViewController ()
{
    UIDatePicker *picker;
}

@end

@implementation UpdateSocialInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setlayout];
    [self.navigationController.navigationBar setHidden:YES];
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
    //[datepicker setMaximumDate:[NSDate date]];
    [self.dateBirthField setInputView:datepicker];
    
    // NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"dd-MM-yyyy"];
    // NSString *date = [dateFormat stringFromDate:[self.profileDict valueForKey:@"dob"]];
    
    NSString *dateString = [[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"dob"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"MMMM dd, yyyy"];
        NSString *stringDate = [dateFormatter1 stringFromDate:dateFromString];
    
    self.dateBirthField.text = stringDate;
    //
    self.firstnameField.text = [[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"first_name"];
    self.lastnameField.text = [[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"last_name"];
    self.zipcodeField.text = [[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"zipcode"];
    self.phoneField.text = [[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"phone_no"];
    // self.cityNameField.text = [self.profileDict valueForKey:@"phone_no"];
    
}

-(void)updateTextField:(id)sender
{
    picker = (UIDatePicker*)self.dateBirthField.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
    // NSString *date = [dateFormat stringFromDate:datePicker.date];
    
    self.dateBirthField.text = [dateFormat stringFromDate:picker.date];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField==_zipcodeField) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 6;
    } else if (textField==_phoneField) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    
    return YES;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)update_user_profile
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    [dict setObject:self.firstnameField.text forKey:@"firstName"];
    [dict setObject:self.lastnameField.text forKey:@"lastName"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"email"] forKey:@"email"];
    [dict setObject:self.phoneField.text forKey:@"phone"];
    [dict setObject:self.dateBirthField.text forKey:@"dob"];
    [dict setObject:self.zipcodeField.text forKey:@"zipcode"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    [[NetworkEngine sharedNetworkEngine]update_user_profile:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             NSDictionary *userdata =  [[object valueForKey:@"Data"] objectAtIndex:0];
             [USERDEFAULTS setObject:userdata forKey:DictUserData];
             [USERDEFAULTS setObject:[userdata valueForKey:@"no_of_unread_messages"] forKey:UnreadMessages];
             
             DashboardViewController *dashBoard = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
             [self.navigationController pushViewController:dashBoard animated:YES];
             
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
         [kAppDelegate hideProgressHUD];
         NSLog(@"Error : %@",error.description);
     }
   params:dict];
}

- (IBAction)updateInfoAction:(id)sender {
    
    [self.firstnameField resignFirstResponder];
    [self.lastnameField resignFirstResponder];
    [self.dateBirthField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.zipcodeField resignFirstResponder];
    
    
    if ([[self.firstnameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.lastnameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.dateBirthField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.zipcodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
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
        
    }else if ([picker.date compare:[NSDate date]] == NSOrderedDescending)
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
        [self update_user_profile];
        
    }
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
