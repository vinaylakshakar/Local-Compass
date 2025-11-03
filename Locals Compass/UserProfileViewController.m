//
//  UserProfileViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-02.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PersonalinfoViewController.h"
#import "ProfileNotificationViewController.h"
#import "UpdatePasswordViewController.h"
#import "ProfileHelpViewController.h"
#import "FeedBackViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "SocialLoginViewController.h"

@interface UserProfileViewController ()
{
    NSMutableDictionary *profileDict;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRoundedView:self.profileImage toDiameter:140.0];
    _profileImage.clipsToBounds = YES;
    [_profileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_profileImage.layer setBorderWidth: 5.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (!isChooseImage)
    {
       
        [self getUserProfile];
    }
    
     isChooseImage= NO;
}

-(void)getUserProfile
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    [[NetworkEngine sharedNetworkEngine]get_user_profile:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             profileDict = [[object valueForKey:@"data"] mutableCopy];
             
             self.profileName.text =[NSString stringWithFormat:@"%@ %@",[profileDict valueForKey:@"first_name"],[profileDict valueForKey:@"last_name"]];
             self.userEmail.text =[profileDict valueForKey:@"email"];
             [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[profileDict valueForKey:@"picture"]]] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
             [self setRoundedView:self.profileImage toDiameter:140.0];
             _profileImage.clipsToBounds = YES;
             
             [self.scrollView setHidden:NO];
             
         } else
         {
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:nil
                                          
                                          message:@"There is some problem with server."
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

#pragma mark - uploadProfileImage


- (void) sendImageToServer {
    
    if(_profileImage.image != nil)
    {
        
        
        //http://localscompass.silappdevops.com/services/update_user_image.php?user_id=1
        
        NSString *str=[kBaseURL stringByAppendingFormat:@"update_user_image.php?user_id=%@",[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"]];
        
        
        NSString *newString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *urlString = [NSString stringWithFormat:@"%@",newString];
        
        
        NSURL *siteURL = [[NSURL alloc] initWithString:urlString];
        
        // create the connection
        NSMutableURLRequest *siteRequest = [NSMutableURLRequest requestWithURL:siteURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:30.0];
        
        // change type to POST (default is GET)
        [siteRequest setHTTPMethod:@"POST"];
        
        // just some random text that will never occur in the body
        NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
        
        // header value
        NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                    stringBoundary];
        
        // set header
        [siteRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
        
        //add body
        NSMutableData *postBody = [NSMutableData data];
        //    pro(@"body made");
        
        //image
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n",@"iphone.png"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *imageData =UIImageJPEGRepresentation(_profileImage.image, 0.1);
        
        [postBody appendData:imageData];
        
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // final boundary
        [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //pr(@"message data post data %@",postBody);
        
        // add body to post
        [siteRequest setHTTPBody:postBody];
        
        NSURLResponse *response;
        NSError *error;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:siteRequest
                                                   returningResponse:&response
                                                               error:&error];
        
        NSString *myString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",dict);
        
        if ([dict[@"Response"] isEqualToString:@"success"]) {
            
            //[CommonFunctions AlertWithMsg:@"User info updated successfully"];
            
            //[USERDEFAULTS setObject:dict[@"Data"] forKey:DictOnBoarding];
            [USERDEFAULTS setObject:[dict[@"Data"] objectAtIndex:0] forKey:DictUserData];

            
        }
        else{
            [kAppDelegate hideProgressHUD];
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:dict[@"Response"]    preferredStyle:UIAlertControllerStyleAlert];
            
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
        
    }
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (IBAction)editProfileAction:(UIButton*)sender
{
    
    
    switch (sender.tag) {
        case 1:
            
        {
            PersonalinfoViewController * personalInfo =[self.storyboard instantiateViewControllerWithIdentifier:@"PersonalinfoViewController"];
            personalInfo.profileDict = profileDict;
            [self.navigationController pushViewController:personalInfo animated:YES];
        }
            
            
            break;
            
        case 2:
        {
            ProfileNotificationViewController *profileNotification =[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileNotificationViewController"];
            [self.navigationController pushViewController:profileNotification animated:YES];
            
        }
            break;
            
        case 3:
        {
            UpdatePasswordViewController *updatePassword =[self.storyboard instantiateViewControllerWithIdentifier:@"UpdatePasswordViewController"];
            [self.navigationController pushViewController:updatePassword animated:YES];
            
        }
            
            break;
            
        case 4:
            
        {
            ProfileHelpViewController *profileHelp =[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileHelpViewController"];
            [self.navigationController pushViewController:profileHelp animated:YES];
            
        }
            break;
            
        case 5:
        {
            
            FeedBackViewController *feedBack =[self.storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
            [self.navigationController pushViewController:feedBack animated:YES];
            
        }
            
            break;
            
        case 6:
        {
            //////Logout////////
            [self logoutUser];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - logoutUser

-(void)logoutUser{
    //localscompass.silappdevops.com/services/logout.php?user_id=1&device_id=1
    
    [kAppDelegate showProgressHUD];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"device_id"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"device_id"];
        
    }
    NSLog(@"%@",dict);
    
    {
        [[NetworkEngine sharedNetworkEngine]userLogout:^(id object){
            NSLog(@"%@",object);

            [self resetDefaults];
//                [USERDEFAULTS removeObjectForKey:LoginfromSocial];
//                [USERDEFAULTS removeObjectForKey:DictUserData];
            
//                SocialLoginViewController *socialloginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SocialLoginViewController"];
                [self.navigationController popToRootViewControllerAnimated:YES];

                [kAppDelegate hideProgressHUD];
            
            
            
        }
                                               onError:^(NSError *error)
         {
             NSLog(@"Error : %@",error);
         }params:dict];
        
    }
    
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateProfileImage:(id)sender {
    
    UIActionSheet *actionSheet_popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Gallery", @"Camera", nil];
    actionSheet_popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet_popupQuery showInView:self.view];
    actionSheet_popupQuery.tag=2;
}

#pragma mark - ACTION SHEET DELEGATE

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self click_gallery];
        
    }
    else if(buttonIndex == 1)
    {
        [self click_camera];
        
    }
}

-(void)click_camera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Alert! " message:@"Device does not support camera" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
    }
}
-(void)click_gallery
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imgPicker= [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageOriginal =  [info objectForKey:UIImagePickerControllerEditedImage];
    
    imgData=UIImageJPEGRepresentation(imageOriginal,0.5);
    
    if (click_reg==YES)
    {
        click_reg=NO;
        
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            _profileImage.image=imageOriginal;
        }
        else
        {
            _profileImage.image=imageOriginal;
            
        }
    }
    else
    {
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            _profileImage.image=imageOriginal;
        }
        else
        {
            _profileImage.image=imageOriginal;
            
        }
    }
    isChooseImage=YES;
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [self sendImageToServer];
    
}

@end

