//
//  ItinerariesCityViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-28.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ItinerariesCityViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface ItinerariesCityViewController ()
{
    
    NSMutableDictionary *cityDetailDict,*likeUnlikeDict;
}

@end

@implementation ItinerariesCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self cityDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateLayout
{
    self.cityName.text = [cityDetailDict valueForKey:@"CityName"];
    self.addressLable.text = [cityDetailDict valueForKey:@"State"];
    self.heighSeasonLabel.text = [cityDetailDict valueForKey:@"HighSeason"];
    self.languageLabel.text = [cityDetailDict valueForKey:@"Language"];
    self.lowSeasonLabel.text = [cityDetailDict valueForKey:@"LowSeason"];
    self.populationLabel.text = [cityDetailDict valueForKey:@"Population"];
    NSString *isRequiredStr = [cityDetailDict valueForKey:@"passportRequirements"];
    self.numberOfLikes.text = [cityDetailDict valueForKey:@"no_of_like"];
    NSString *islikedStr = [cityDetailDict valueForKey:@"isLiked"];
    
    NSString *planMade = [cityDetailDict valueForKey:@"no_of_itinerary"]; // no_of_itinerary
    NSString *str = @"Itineraries Completed"; //str to concat
    NSString *noOfPlans = [NSString stringWithFormat: @"%@ %@", planMade, str];
    
    self.numberOfPlans.text = noOfPlans;
    [self.numberOfPlans sizeToFit];
    
    NSString *localsAvailable = [cityDetailDict valueForKey:@"NOOfLocals"]; //NO Of Locals
    NSString *fixedStr = @"Locals Available"; //str to concat
    NSString *localsCount = [NSString stringWithFormat: @"%@ %@", localsAvailable, fixedStr]; //concatinated Result
    
    self.numberOfLocals.text = localsCount; //NO Of Locals
    [self.numberOfLocals sizeToFit];
    
    [self.cityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[cityDetailDict valueForKey:@"BigImageURl"]]] placeholderImage:[UIImage imageNamed:@"city_detail_dummy"] options:0 progress:nil completed:nil];
    
    if ([isRequiredStr isEqualToString:@"1"]) {
        self.passportRequirementLable.text =@"YES";
    } else {
         self.passportRequirementLable.text =@"NO";
    }
    
    if (islikedStr == (id)[NSNull null] || islikedStr.length == 0 )
    {
        [self.likeUnlikeBtn setSelected:NO];
    }
    else if ([islikedStr isEqualToString:@"1"])
    {
        [self.likeUnlikeBtn setSelected:YES];
    }
    self.bestTimeToGoLabel.text = [cityDetailDict valueForKey:@"BestTimeToGo"];
    self.cityDetailTextView.text = [cityDetailDict valueForKey:@"CityDesc"];
    [self.cityName sizeToFit];
    self.addressLable.frame = CGRectMake(self.cityName.frame.origin.x + self.cityName.frame.size.width+10, self.cityName.frame.origin.y, self.addressLable.frame.size.width, self.cityName.frame.size.height);

    [self.cityDetailTextView sizeToFit];
    
    self.cityDetailTextView.frame = CGRectMake(0, self.cityDetailTextView.frame.origin.y, self.view.frame.size.width, self.cityDetailTextView.frame.size.height+10);
    self.upperView.frame = CGRectMake(self.upperView.frame.origin.x, self.upperView.frame.origin.y, self.view.frame.size.width, self.upperView.frame.size.height);
    self.lowerView.frame = CGRectMake(self.lowerView.frame.origin.x, self.cityDetailTextView.frame.origin.y+self.cityDetailTextView.frame.size.height, self.view.frame.size.width, self.lowerView.frame.size.height);
    self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y, self.containerView.frame.size.width, self.lowerView.frame.origin.y + 20+ self.lowerView.frame.size.height);
    
    [self.containerView setHidden:NO];
}

-(void)cityDetails
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.cityIDStr forKey:@"cityId"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]city_details:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             cityDetailDict = [[[object valueForKey:@"Data"] objectAtIndex:0] mutableCopy];
             [self updateLayout];
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

-(void)CityLike
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.cityIDStr forKey:@"cityId"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    
    if (![self.likeUnlikeBtn  isSelected])
    {
        [dict setObject:@"1" forKey:@"isLiked"];
        
    } else {
        [dict setObject:@"0" forKey:@"isLiked"];
    }
    
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]city_like:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             likeUnlikeDict = [[[object valueForKey:@"Data"] objectAtIndex:0]  mutableCopy];
             self.numberOfLikes.text = [likeUnlikeDict valueForKey:@"No_Of_Likes"];
             if (![self.likeUnlikeBtn  isSelected])
             {
                 [self.likeUnlikeBtn setSelected:YES];
                 
             } else {
                 [self.likeUnlikeBtn setSelected:NO];
             }
             
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
- (IBAction)likeUnlikeAction:(id)sender {
    
    [self CityLike];
}
@end
