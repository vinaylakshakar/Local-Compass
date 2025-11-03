//
//  OnboardingViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-19.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "OnboardingViewController.h"
#import "DashboardViewController.h"
#import "NetworkEngine.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface OnboardingViewController ()

@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRoundedView:self.uploadImage toDiameter:100.0];
    _uploadImage.clipsToBounds = YES;
    [_uploadImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_uploadImage.layer setBorderWidth: 5.0];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField==_zipCodeField) {
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

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)uploadImageAction:(id)sender {
    
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
            _uploadImage.image=imageOriginal;
        }
        else
        {
            _uploadImage.image=imageOriginal;
            
        }
    }
    else
    {
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            _uploadImage.image=imageOriginal;
        }
        else
        {
            _uploadImage.image=imageOriginal;
            
        }
    }
    isChooseImage=YES;
    [picker dismissViewControllerAnimated:YES completion:Nil];
    //  [self PostData];
    
}

//Rajat Code Start......

-(void)informationUpdated{
    
    if([[self.zipCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
        
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
        
        
    }else if (isChooseImage==NO)
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please Select Profile Image."   preferredStyle:UIAlertControllerStyleAlert];
        
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
    
    else
    {
        
        [kAppDelegate showProgressHUD];
        [self sendImageToServer];
        
    }
}
//Rajat code Start.....
- (void) sendImageToServer {
    
    if(_uploadImage.image != nil)
    {
        
        
        //http://localscompass.silappdevops.com/services/onboarding_screen.php?user_id=113&zipcode=123&phone=123456
        
        NSString *str=[kBaseURL stringByAppendingFormat:@"onboarding_screen.php?user_id=%@&zipcode=%@&phone=%@",[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"],self.zipCodeField.text,self.phoneField.text];
        
        
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
        
        NSData *imageData;
        
        if (isChooseImage==YES) {
              imageData=UIImageJPEGRepresentation(_uploadImage.image, 0.1);
        } else {
             imageData =UIImageJPEGRepresentation([UIImage imageNamed:@"no_image"], 0.1);
        }
       
        
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
            NSMutableDictionary* userData = [[dict[@"Data"] objectAtIndex:0] mutableCopy];
            
//            NSMutableArray *ArrayOnBoarding = [dict[@"Data"] mutableCopy];
//
//
//            [userData setObject:self.zipCodeField.text forKey:@"zipcode"];
//
//            [userData setObject:self.phoneField.text forKey:@"phone_no"];
//
//            [userData setObject:[[ArrayOnBoarding objectAtIndex:0] objectForKey:@"picture"] forKey:@"picture"];
//
//            [userData setObject:[[ArrayOnBoarding objectAtIndex:0] objectForKey:@"no_of_unread_messages"] forKey:@"no_of_unread_messages"];
//
//            [userData setObject:[[ArrayOnBoarding objectAtIndex:0] objectForKey:@"is_first_login"] forKey:@"is_first_login"];
            
            NSLog(@"%@",userData);
            
            [USERDEFAULTS setObject:userData forKey:DictUserData];
            [USERDEFAULTS setObject:[userData valueForKey:@"no_of_unread_messages"] forKey:UnreadMessages];
            
            //[USERDEFAULTS setObject:dict[@"Data"] forKey:DictOnBoarding];

            DashboardViewController *dashBoard =[self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.navigationController pushViewController:dashBoard animated:YES];
            
        }
        else{
            [kAppDelegate hideProgressHUD];
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:myString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        }
        
    }
}


//Rajat Code end.....
- (IBAction)finishBtnAction:(id)sender
{
    [self informationUpdated];
    
}
////Rajat Code End......
@end

