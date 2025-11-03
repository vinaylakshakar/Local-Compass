//
//  RateItineraryViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-29.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "RateItineraryViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface RateItineraryViewController ()

@end

@implementation RateItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button =[self.view viewWithTag:4];
    [button setSelected:YES];
    
    [_scrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, self.mainView.frame.size.height)];
    [self updateView];
    NSLog(@"%@",_itineraryDict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)convertDateFormat:(NSString*)DateStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:DateStr];
    
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *finalStartDate= [dateFormatter stringFromDate:orignalDate];
    
    return finalStartDate;
}


-(void)updateView{
    
    [self.cityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_itineraryDict objectForKey:@"city_image"]]] placeholderImage:[UIImage imageNamed:@"detail_dummy01"] options:SDWebImageRefreshCached progress:nil completed:nil];
    
    NSString *address = [_itineraryDict valueForKey:@"address"];
    NSString *itineraryID = [_itineraryDict valueForKey:@"itinerary_request_id"];
    
    self.itineraryTitle.text = address;
    self.itineraryLabel.text = [NSString stringWithFormat:@"Itinerary ID: %@",itineraryID];
    self.itineraryDate.text =[NSString stringWithFormat:@"%@-%@",[self convertDateFormat:[_itineraryDict valueForKey:@"StartDate"]],[self convertDateFormat:[_itineraryDict valueForKey:@"EndDate"]]];

}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView ==_descriptionView) {
        _descriptionView.text = @"";
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_descriptionView.text.length == 0){
        _descriptionView.text = @"Share Your Experience";
        [_descriptionView resignFirstResponder];
    }
}

-(void)RateItinerary
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[_itineraryDict valueForKey:@"itinerary_request_id"] forKey:@"itinerary_id"];
    [dict setObject:self.ratingLabel.text forKey:@"rating"];
    [dict setObject:self.descriptionView.text forKey:@"description"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]rate_itinerary:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
            
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:nil
                                          
                                          message:@"You have rated Itinerary Successfully."
                                          preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                             
                                          [self.navigationController popViewControllerAnimated:YES];
                                             
                                         }];
             
             [alert addAction:yesButton];
             [self presentViewController:alert animated:YES completion:nil];
  
             
         } else
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)rateBtnAction:(UIButton*)sender {
    
    for (int i=1; i<=5; i++) {
        UIButton *button =[self.view viewWithTag:i];
        [button setSelected:NO];
    }
    
    [sender setSelected:YES];
    [self.ratingLabel setText:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    
}
- (IBAction)submitRatingAction:(id)sender {
    
    if ([[self.descriptionView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Share your experience"]||[[self.ratingLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please Enter The Description."   preferredStyle:UIAlertControllerStyleAlert];
        
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
        
          [self RateItinerary];
    }
    
  
}
- (IBAction)exportPdfAction:(id)sender {
    
    NSString* pdfURL = [NSString stringWithFormat:@"%@",self.pdfUrlStr];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: pdfURL] options:@{} completionHandler:^(BOOL success) {}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: pdfURL]];
    }
}
@end
