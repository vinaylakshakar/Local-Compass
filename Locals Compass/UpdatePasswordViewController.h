//
//  UpdatePasswordViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-02.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UIViewController
- (IBAction)updateBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *reTypePasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
