//
//  DashboardViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-20.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "DashboardViewController.h"
#import "CityDetailsViewController.h"
#import "LocalDetailViewController.h"
#import "ItineraryListingViewController.h"
#import "ChooseCityCell.h"
#import "ChooseLocalCell.h"
#import "UserProfileViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface DashboardViewController ()
{

    CGRect frame;
    NSMutableArray *city_listArray,*local_listArray;
}

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRoundedView:self.noOfMessageLabel toDiameter:20.0];
    self.noOfMessageLabel.clipsToBounds = YES;
    frame = self.underLineView.frame;
    [_chooseCityBtn setSelected:YES];
    [_chooseCityBtn setTitleColor:[UIColor colorWithRed:0.20 green:0.77 blue:0.94 alpha:1.0] forState:UIControlStateSelected];
    [_chooseCityLocal setTitleColor:[UIColor colorWithRed:0.20 green:0.77 blue:0.94 alpha:1.0] forState:UIControlStateSelected];
    
    
    //[self citySearching];
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
   // [self setSearch];
   
    [self setLayout];
}

-(void)setSearch
{
    if ([self.searchField.text isEqualToString:@""])
    {
        [self.clearSearchBtn setHidden:YES];
        [self cityListing];
    }else
    {
        [self.clearSearchBtn setHidden:NO];
        [self citySearching];
    }
    
   // [self setLayout];
    
    
}

-(void)setRoundedView:(UILabel *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if ([self.searchField.text isEqualToString:@""]) {
        [self.searchField resignFirstResponder];
        
        if ([self.chooseCityBtn isSelected])
        {
             [self cityListing];
        }
        if ([self.chooseCityLocal isSelected])
        {
            [self locals_listing];
        }
       
        [self.clearSearchBtn setHidden:YES];
    }else
    {
        [self.clearSearchBtn setHidden:NO];
    }
}


-(void)setLayout
{
    self.enRouteView.layer.cornerRadius = 5;
    self.enRouteView.layer.masksToBounds = true;
    
    self.thankyouView.layer.cornerRadius = 5;
    self.thankyouView.layer.masksToBounds = true;
    
    self.navigationController.navigationBarHidden =YES;
    
    self.noOfMessageLabel.text = [USERDEFAULTS valueForKey:UnreadMessages];
   [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"picture"]]] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
    [self setRoundedImageView:self.profileImage toDiameter:30.0];
    _profileImage.clipsToBounds = YES;
    
    //NSLog(@"%@",[USERDEFAULTS valueForKey:UnreadMessages]);
    
    [self setSearch];
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [_searchField resignFirstResponder];
    if ([self.chooseCityBtn isSelected]||([self.chooseCityLocal isSelected]))
    {
        if (self.searchField.text.length!=0) {
            [self citySearching];
        } 
       
    }
    
    return YES;
}

-(void)citySearching
{
    NSString *cityname = [self.searchField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    //NSLog(@"%@",cityname);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:cityname forKey:@"cityName"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
   // NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]city_search:^(id object)///
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             city_listArray = [[[object valueForKey:@"Data"] valueForKey:@"city_data"] mutableCopy];
             local_listArray = [[[object valueForKey:@"Data"] valueForKey:@"local_data"] mutableCopy];
             [self SetTableView];
             //[self locals_listing];
             
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

-(void)SetTableView
{
    if (([self.chooseCityLocal isSelected] && local_listArray.count==0) || ([self.chooseCityBtn isSelected] && city_listArray.count==0) )
    {
        [self.dashboardTable setHidden:YES];
    }
    else
    {
        [self.dashboardTable setHidden:NO];
    }
    
    [self.dashboardTable reloadData];
    
    
    if (city_listArray.count==0 && [self.chooseCityBtn isSelected] && ![self.searchField.text isEqualToString:@""])
    {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     
                                     message:@"If you'd like us to notifiy you once we reach this city, please click OK"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        [self.effectView setHidden:NO];
                                        [self.enRouteView setHidden:NO];
                                    }];
        UIAlertAction* Cancel = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                    }];
        
        [alert addAction:Cancel];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
      
    }
    
}

-(void)cityListing
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"page_no"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    [[NetworkEngine sharedNetworkEngine]city_list:^(id object)
     {
         NSLog(@"%@",object);
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             city_listArray = [[object valueForKey:@"Data"] mutableCopy];

                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //update UI in main thread.
                                  [self locals_listing];
                                  [self.dashboardTable reloadData];
                                 //
                              });
             
            
//             dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                 //load your data here.
//                  //
//
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     //update UI in main thread.
//
//                    //
//                 });
//             });

             
             
           
             
         } else
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
         
         
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)locals_listing
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"page_no"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    
    [[NetworkEngine sharedNetworkEngine]locals_list:^(id object)
     {
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             local_listArray = [[object valueForKey:@"Data"] mutableCopy];
             [self SetTableView];
             if ([self.chooseCityLocal isSelected])
             {
                 [self.dashboardTable reloadData];
             }
             
         } else
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

-(void)setRoundedImageView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

//tableview delegate-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.chooseCityBtn isSelected])
    {
        return city_listArray.count;
    }
    return local_listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ChooseCityCell";
    static NSString *propertyIdentifier = @"ChooseLocalCell";
    
    ChooseCityCell *cell = (ChooseCityCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    ChooseLocalCell *cell1 = (ChooseLocalCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChooseCityCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ChooseLocalCell" owner:self options:nil];
        cell1 = [nib1 objectAtIndex:0];
    }
    
    if ([self.chooseCityBtn isSelected]) {
        
        NSString *cityNameStr =[[city_listArray objectAtIndex:indexPath.row] valueForKey:@"CityName"];
        cell.cityName.text = cityNameStr;
        cell.cityAddress.text = [[city_listArray objectAtIndex:indexPath.row] valueForKey:@"State"];
        [cell.cityName sizeToFit];
        
        NSString *islikedStr = [[city_listArray objectAtIndex:indexPath.row] valueForKey:@"isLiked"];

        if ([islikedStr isEqualToString:@"1"]) {
            [cell.likeUnLikeBtn setSelected:YES];
        }
        
        cell.cityAddress.frame = CGRectMake(cell.cityName.frame.origin.x + cell.cityName.frame.size.width+10, cell.cityAddress.frame.origin.y, cell.cityAddress.frame.size.width, cell.cityAddress.frame.size.height);
        cell.cityLikes.text =[[city_listArray objectAtIndex:indexPath.row] valueForKey:@"NOOfLikes"];
        cell.localsAvailabiltyLabel.text = [NSString stringWithFormat:@"%@ Locals Available",[[city_listArray objectAtIndex:indexPath.row] valueForKey:@"NOOfLocals"]];
        cell.cityPlansLabel.text = [NSString stringWithFormat:@"%@ Itineraries Completed",[[city_listArray objectAtIndex:indexPath.row] valueForKey:@"NOOfItinerary"]];
        [cell.cityPlansLabel sizeToFit];
        [cell.localsAvailabiltyLabel sizeToFit];
//         NSString *cityImageUrl = [[NSString stringWithFormat:@"%@",[[city_listArray objectAtIndex:indexPath.row] valueForKey:@"ImageURl"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *compressedImgURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_image.php?file_name=%@&width=404&height=238",kBaseURL,[[city_listArray objectAtIndex:indexPath.row] valueForKey:@"ImageURl"]]];
        
//        NSURL *compressedImgURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://localscompass.silappdevops.com/uploads/new_356x608_newyork.jpg"]];
        
        [cell.cityImage sd_setImageWithURL:compressedImgURL1 placeholderImage:nil options:SDWebImageRefreshCached progress:nil completed:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }else
    {
        cell1.localNameLabel.text = [NSString stringWithFormat:@"%@ %@.",[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"FirstName"],[[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"LastName"] substringToIndex:1]];
        NSString *islikedStr = [[local_listArray objectAtIndex:indexPath.row] valueForKey:@"isLiked"];
        
        if ([islikedStr isEqualToString:@"1"]) {
            [cell1.likeUnlikeBtn setSelected:YES];
        }
        cell1.localAddressLabel.text = [NSString stringWithFormat:@"%@, %@",[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"CityName"],[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"State"]];
        cell1.itineraryNumber.text = [NSString stringWithFormat:@"%@ Itineraries",[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"No_Of_Itinerary"]];
        cell1.budgetNumber.text = [NSString stringWithFormat:@"%@ Badges",[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"No_Of_Badges"]];
        cell1.likeNumber.text = [[local_listArray objectAtIndex:indexPath.row] valueForKey:@"No_Of_Likes"];
        
         NSString *profileImg = [[NSString stringWithFormat:@"%@",[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"Picture"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell1.profileImage sd_setImageWithURL:[NSURL URLWithString:profileImg] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
        [self setRoundedImageView:cell1.profileImage toDiameter:70.0];
        cell1.profileImage.clipsToBounds = YES;
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell1;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.chooseCityBtn isSelected]) {
        return 250;
    }
    
    return 100;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.chooseCityBtn isSelected])
    {
        CityDetailsViewController *cityDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"CityDetailsViewController"];
        cityDetail.cityIDStr = [[city_listArray objectAtIndex:indexPath.row] valueForKey:@"CityId"];
        [self.navigationController pushViewController:cityDetail animated:YES];
        
        
    }else
    {
        LocalDetailViewController *localDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"LocalDetailViewController"];
        localDetail.localIDStr = [[local_listArray objectAtIndex:indexPath.row] valueForKey:@"UserId"];
        [USERDEFAULTS setObject:[[local_listArray objectAtIndex:indexPath.row] valueForKey:@"UserId"] forKey:UserID];
        [self.navigationController pushViewController:localDetail animated:YES];
    }

}

- (IBAction)chooseCityBtnAction:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.underLineView.frame = frame;
        [sender setSelected:YES];
        [self.chooseCityLocal setSelected:NO];
        [_backGroundImageView setImage:[UIImage imageNamed:@"city_empty_dummy"]];
         [_backGroundLabel setText:@"No city available!"];
        [self SetTableView];
        [_dashboardTable reloadData];
        [_dashboardTable setBackgroundColor:[UIColor whiteColor]];
        
//        ...
        
    }completion:^(BOOL finished) {
//        ...
    }];
}

- (IBAction)chooseLocalBtnAction:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.underLineView.frame = CGRectMake(frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        [sender setSelected:YES];
        [self.chooseCityBtn setSelected:NO];
        [_backGroundImageView setImage:[UIImage imageNamed:@"locals_empty_dummy"]];
        [_backGroundLabel setText:@"No Local available!"];
        [self SetTableView];
        [_dashboardTable reloadData];
        [_dashboardTable setBackgroundColor:[UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.0]];

        //        ...
        if (local_listArray.count<=0) {
            [self locals_listing];
        }
        
    }completion:^(BOOL finished) {
        //        ...

    }];
}
- (IBAction)tapOnBlurrView:(id)sender {
    
    [_effectView setHidden:YES];
}

- (IBAction)enRouteAction:(id)sender {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.searchField.text forKey:@"city_name"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    
    
   // NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]new_city:^(id object)///
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {

             [self.enRouteView setHidden:YES];
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
- (IBAction)itinerariesListAction:(id)sender {
    
    ItineraryListingViewController *itineraryList =[self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryListingViewController"];
    [self.navigationController pushViewController:itineraryList animated:YES];
}

- (IBAction)profileBtnAction:(id)sender {
    
    UserProfileViewController *userProfile =[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    [self.navigationController pushViewController:userProfile animated:YES];
}
- (IBAction)cleaseSearch:(id)sender
{
      self.searchField.text =@"";
      [self setSearch];
      [self locals_listing];
}
@end
