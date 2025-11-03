//
//  OnboardingViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-19.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    BOOL click_reg;
    UIImage *imageOriginal;
    NSData *imgData;
    BOOL isChooseImage;
    
}
- (IBAction)backBtnAction:(id)sender;
- (IBAction)uploadImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
- (IBAction)finishBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;


@end
