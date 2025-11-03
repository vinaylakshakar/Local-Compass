//
//  PersonalinfoViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-02.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface PersonalinfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *contactNumberField;
@property (weak, nonatomic) IBOutlet UITextField *cityNameField;
@property (weak, nonatomic) IBOutlet UITextField *birthDateField;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)updateBtnAction:(id)sender;

@property (weak, nonatomic) NSMutableDictionary *profileDict;

@end
