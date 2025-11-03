//
//  CityDetailsViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-21.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "CityDetailsViewController.h"
#import "ChooseLocalCell.h"
#import "LocalDetailViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface CityDetailsViewController ()
{
    
    NSMutableDictionary *cityDetailDict,*likeUnlikeDict;
    NSMutableArray *arrLocalsAvailable;
}

@end

@implementation CityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    //Api call
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
    NSString *islikedStr = [cityDetailDict valueForKey:@"isLiked"];
    
    
    //Rajat Code Start......
    
    
    self.numberOfLikes.text =[cityDetailDict valueForKey:@"no_of_like"]; //no_of_likes
    
    NSString *localsAvailable = [cityDetailDict valueForKey:@"NOOfLocals"]; //NO Of Locals
    NSString *fixedStr = @"Locals Available"; //str to concat
    NSString *localsCount = [NSString stringWithFormat: @"%@ %@", localsAvailable, fixedStr]; //concatinated Result
    
    self.numberOfLocals.text = localsCount; //NO Of Locals
    [self.numberOfLocals sizeToFit];
    arrLocalsAvailable = [[cityDetailDict objectForKey:@"local_users"] mutableCopy];
    
    NSString *planMade = [cityDetailDict valueForKey:@"no_of_itinerary"]; // no_of_itinerary
    NSString *str = @"Itineraries Completed"; //str to concat
    NSString *noOfPlans = [NSString stringWithFormat: @"%@ %@", planMade, str];
    
    self.numberOfPlans.text = noOfPlans;
    [self.numberOfPlans sizeToFit];
    
    
    //Rajat Code End.....
    
    [self.cityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[cityDetailDict valueForKey:@"BigImageURl"]]] placeholderImage:nil options:0 progress:nil completed:nil];
    
    if ([isRequiredStr isEqualToString:@"1"]) {
        self.passportRequirementLable.text =@"YES";
    } else {
        self.passportRequirementLable.text =@"NO";
    }
    
    if ([islikedStr isEqualToString:@"1"]) {
        [self.likeUnlikeBtn setSelected:YES];
    }
    self.bestTimeToGoLabel.text = [cityDetailDict valueForKey:@"BestTimeToGo"];
    self.cityDetailTextView.text = [cityDetailDict valueForKey:@"CityDesc"];
    [self.cityName sizeToFit];
    self.addressLable.frame = CGRectMake(self.cityName.frame.origin.x + self.cityName.frame.size.width+10, self.addressLable.frame.origin.y, self.addressLable.frame.size.width, self.addressLable.frame.size.height);
    
    [self.cityDetailTextView sizeToFit];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height > 568)
        {
            // iPhone >5
            if (self.cityDetailTextView.frame.size.height>250)
            {
                self.cityDetailTextView.frame = CGRectMake(0, self.cityDetailTextView.frame.origin.y, self.view.frame.size.width, self.cityDetailTextView.frame.size.height-70);
            }else
            {
                self.cityDetailTextView.frame = CGRectMake(0, self.cityDetailTextView.frame.origin.y, self.view.frame.size.width, self.cityDetailTextView.frame.size.height);
            }
        }else
        {
            if (self.cityDetailTextView.frame.size.height>70)
            {
                self.cityDetailTextView.frame = CGRectMake(0, self.cityDetailTextView.frame.origin.y, self.view.frame.size.width, self.cityDetailTextView.frame.size.height-5);
            }else
            {
                self.cityDetailTextView.frame = CGRectMake(0, self.cityDetailTextView.frame.origin.y, self.view.frame.size.width, self.cityDetailTextView.frame.size.height);
            }
            
        }
    }
    
//    self.cityDetailTextView.frame = CGRectMake(0, self.cityDetailTextView.frame.origin.y, self.view.frame.size.width, self.cityDetailTextView.frame.size.height);
    self.upperView.frame = CGRectMake(self.upperView.frame.origin.x, self.upperView.frame.origin.y, self.view.frame.size.width, self.upperView.frame.size.height);
    self.lowerView.frame = CGRectMake(self.lowerView.frame.origin.x, self.cityDetailTextView.frame.origin.y+self.cityDetailTextView.frame.size.height, self.view.frame.size.width, self.lowerView.frame.size.height);
    self.labelAvailabiltiy.frame = CGRectMake(0, self.lowerView.frame.origin.y + self.lowerView.frame.size.height+20, self.view.frame.size.width, self.labelAvailabiltiy.frame.size.height);
    self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y, self.containerView.frame.size.width, self.labelAvailabiltiy.frame.origin.y + 20+ self.labelAvailabiltiy.frame.size.height);
    
    [self.containerView setHidden:NO];
    [self.tableview reloadData];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrLocalsAvailable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *propertyIdentifier = @"ChooseLocalCell";
    
    ChooseLocalCell *cell = (ChooseLocalCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {

        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ChooseLocalCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
    cell.localNameLabel.text = [[arrLocalsAvailable objectAtIndex:indexPath.row] objectForKey:@"full_name"];
    
    cell.localAddressLabel.text = [[arrLocalsAvailable objectAtIndex:indexPath.row] valueForKey:@"address"];
    
    NSString *planMade = [[arrLocalsAvailable objectAtIndex:indexPath.row] valueForKey:@"no_of_itinerary"]; // no_of_itinerary
    NSString *str = @"Itineraries"; //str to concat
    NSString *noOfPlans = [NSString stringWithFormat: @"%@ %@", planMade, str];
    
    cell.itineraryNumber.text = noOfPlans;
    
    NSString *Badge = [[arrLocalsAvailable objectAtIndex:indexPath.row] valueForKey:@"no_of_badges"]; // no_of_itinerary
    NSString *strBadge = @"Badges"; //str to concat
    NSString *noOfBadge = [NSString stringWithFormat: @"%@ %@", Badge, strBadge];
    
    cell.budgetNumber.text = noOfBadge;
    cell.likeNumber.text = [[arrLocalsAvailable objectAtIndex:indexPath.row] valueForKey:@"no_of_likes"];
    
    NSString *islikedStr = [[arrLocalsAvailable objectAtIndex:indexPath.row] valueForKey:@"is_liked"];
    NSString *profileImg = [[NSString stringWithFormat:@"%@",[[arrLocalsAvailable objectAtIndex:indexPath.row] valueForKey:@"picture"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:profileImg] placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageRefreshCached progress:nil completed:nil];
    
    if ([islikedStr isEqualToString:@"1"]) {
        [cell.likeUnlikeBtn setSelected:YES];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalDetailViewController *localDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"LocalDetailViewController"];
    localDetail.localIDStr = [[arrLocalsAvailable objectAtIndex:indexPath.row] valueForKey:@"user_id"];
    [self.navigationController pushViewController:localDetail animated:YES];
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cityLikeAction:(id)sender {
    
    [self CityLike];
}
@end
