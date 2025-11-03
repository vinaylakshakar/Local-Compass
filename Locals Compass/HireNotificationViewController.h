//
//  HireNotificationViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HireNotificationViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *daysNumberField;
@property (weak, nonatomic) IBOutlet UIView *expertView;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)continueBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
