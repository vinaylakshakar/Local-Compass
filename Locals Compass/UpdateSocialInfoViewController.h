//
//  UpdateSocialInfoViewController.h
//  Locals Compass
//
//  Created by Developer on 05/12/17.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateSocialInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *dateBirthField;
- (IBAction)updateInfoAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;

@end
