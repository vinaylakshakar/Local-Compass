//
//  UserProfileViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-02.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL click_reg;
    UIImage *imageOriginal;
    NSData *imgData;
    BOOL isChooseImage;
    
}

- (IBAction)editProfileAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)updateProfileImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
