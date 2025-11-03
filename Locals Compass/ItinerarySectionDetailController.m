//
//  ItinerarySectionDetailController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-28.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ItinerarySectionDetailController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface ItinerarySectionDetailController ()
{
    
    NSMutableDictionary *sectionDetailDict;
}

@end

@implementation ItinerarySectionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self itinerary_section_detail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLayout
{
    self.eventTitle.text =[sectionDetailDict valueForKey:@"title"];
    self.eventAddress.text =[sectionDetailDict valueForKey:@"address"];
    self.phoneNumber.text =[NSString stringWithFormat:@"Ph.%@",[sectionDetailDict valueForKey:@"phoneno"]];
    self.time_to_spend.text =[sectionDetailDict valueForKey:@"reccommended_time_to_spend"];
    self.time_to_go.text =[sectionDetailDict valueForKey:@"reccommended_time_to_go"];
    self.detailTextView.text =[sectionDetailDict valueForKey:@"description"];
    self.noteTextView.text =[sectionDetailDict valueForKey:@"notes"];
    self.operationHourLable.text =[sectionDetailDict valueForKey:@"hours"];
    
    [self.sectionImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[sectionDetailDict valueForKey:@"photo"]]] placeholderImage:nil options:0 progress:nil completed:nil];
    
    [self.detailTextView sizeToFit];
    [self.noteTextView sizeToFit];
    
    self.detailTextView.frame = CGRectMake(0, self.detailTextView.frame.origin.y, self.view.frame.size.width, self.detailTextView.frame.size.height);
    self.upperView.frame = CGRectMake(self.upperView.frame.origin.x, self.upperView.frame.origin.y, self.view.frame.size.width, self.upperView.frame.size.height);
    self.middleView.frame = CGRectMake(0, self.detailTextView.frame.origin.y+self.detailTextView.frame.size.height+14, self.view.frame.size.width, self.middleView.frame.size.height);
    self.lowerView.frame = CGRectMake(0, self.middleView.frame.origin.y + self.middleView.frame.size.height+14, self.view.frame.size.width, self.noteTextView.frame.size.height+35);
    self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.detailView.frame.origin.y, self.view.frame.size.width, self.lowerView.frame.origin.y + self.lowerView.frame.size.height);
    
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, self.detailView.frame.size.height)];
    
    [self.detailView setHidden:NO];
}

-(void)itinerary_section_detail
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.activityIDStr forKey:@"activity_id"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]itinerary_section_detail:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             sectionDetailDict = [[object valueForKey:@"data"] mutableCopy];
             [self setLayout];
         }
         else
         {
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:nil
                                          
                                          message:[object valueForKey:@"msg"]
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

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getDirectionAction:(id)sender {
    
    NSLog(@"%@",self.DirectionDict);
    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f",[[self.DirectionDict valueForKey:@"sourceLat"] doubleValue], [[self.DirectionDict valueForKey:@"sourceLon"] doubleValue]];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:@{} completionHandler:^(BOOL success) {}];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL]];
    }
}
@end
