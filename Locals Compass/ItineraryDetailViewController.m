//
//  ItineraryDetailViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-26.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ItineraryDetailViewController.h"
#import "ItineraryDetailCell.h"
#import "ItinerariesCityViewController.h"
#import "ItinerarySectionDetailController.h"
#import "RateItineraryViewController.h"
#import "ChatViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface ItineraryDetailViewController ()
{
    NSMutableArray *itinararyDayArray;
    NSMutableDictionary *dictItinararyDetails;
    NSString *dayNo;
}

@end

@implementation ItineraryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    if (self.isProcess==YES)
    {
        [self.inprocessView setHidden:NO];
    }

    
    [self setRoundedView:self.profileImage toDiameter:120.0];
    _profileImage.clipsToBounds = YES;
    [_profileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_profileImage.layer setBorderWidth: 5.0];
    
    self.itineraryTable.estimatedRowHeight = 44.0;
    self.itineraryTable.rowHeight = UITableViewAutomaticDimension;
    
    [self itinerary_process];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)itinerary_day_activity
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.itineraryStr forKey:@"itinerary_id"];
#pragma mark - day no--------
    
    [dict setObject:dayNo forKey:@"day_no"];
    
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]itinerary_day_activity:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             itinararyDayArray = [[object valueForKey:@"data"] mutableCopy];
             [self.itineraryTable reloadData];
             [self.messageLabel setHidden:YES];
             
             
         } else
         {
             
//             UIAlertController * alert = [UIAlertController
//                                          alertControllerWithTitle:nil
//
//                                          message:[object valueForKey:@"Message"]
//                                          preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction
//                                         actionWithTitle:@"OK"
//                                         style:UIAlertActionStyleDefault
//                                         handler:^(UIAlertAction * action) {
//                                             //Handle your yes please button action here
//                                         }];
//
//             [alert addAction:yesButton];
             
             [itinararyDayArray removeAllObjects];
             //itinararyDayArray = [[object valueForKey:@"Message"] mutableCopy];
             [self.itineraryTable reloadData];
             [self.messageLabel setHidden:NO];
//             [self presentViewController:alert animated:YES completion:nil];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     }
                                                       onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


-(void)itinerary_process
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.itineraryStr forKey:@"itinerary_id"];
    
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]itinerary_process:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             // [kAppDelegate hideProgressHUD];
             
             
             dictItinararyDetails = [object valueForKey:@"data"];
             [self updateView];
 
             
             
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
         
         
        // [kAppDelegate hideProgressHUD];
         
         
     }
                                                  onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


-(void)updateView{
    
    
    [self createScrollViewMenu];
    
    NSString *profileImg = [[NSString stringWithFormat:@"%@",[dictItinararyDetails objectForKey:@"picture"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:profileImg] placeholderImage:[UIImage imageNamed:@"no_image"] options:SDWebImageRefreshCached progress:nil completed:nil];
    
    NSString *address = [dictItinararyDetails valueForKey:@"address"];
    NSString *fullName = [dictItinararyDetails valueForKey:@"fullName"];
    
    self.addressLbl.text = address;
    self.displayNameLbl.text = fullName;
    
    [self.cityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dictItinararyDetails objectForKey:@"city_image"]]] placeholderImage:[UIImage imageNamed:@"detail_dummy01"] options:SDWebImageRefreshCached progress:nil completed:nil];
    
    if (dayNo)
    {
         [self itinerary_day_activity];
    }else
    {
        
        [kAppDelegate hideProgressHUD];
    }
   
    
    [self.itineraryTable setHidden:NO];
}


-(void)acceptItinerary
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.itineraryStr forKey:@"itinerary_id"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]accept_itinerary:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             // [kAppDelegate hideProgressHUD];
             [self.inprocessView setHidden:YES];
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

-(void)changeItinerary
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.itineraryStr forKey:@"itinerary_id"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    
    NSString *changeRequest =[NSString stringWithFormat:@"Request Changes For Itinerary %@-,%@",self.addressLbl.text,self.descriptionView.text];
    
    [dict setObject:changeRequest forKey:@"change_description"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]change_itinerary:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             // [kAppDelegate hideProgressHUD];
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:nil
                                          
                                          message:@"Sent successfully."
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

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)createScrollViewMenu
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.itineraryView.frame.size.height-30, self.view.frame.size.width, 30)];
#pragma mark - no of days btn
    int x = 0;
    NSString *a = [dictItinararyDetails objectForKey:@"no_of_days"];
    int no_of_days = a.intValue;
    for (int i = 0; i < no_of_days; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, self.view.frame.size.width/4, 30)];
        [button setTitle:[NSString stringWithFormat:@"DAY %d", i+1] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchDown];
        button.tag = i+1;
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.20 green:0.77 blue:0.94 alpha:1.0] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Bold" size:15];
        // [[button.tag = 0]]
        if(button.tag == 1){
            [button setSelected:true];
            dayNo = [NSString stringWithFormat:@"%li", (long)button.tag];
        }
        [scrollView addSubview:button];
        
        x += button.frame.size.width;
    }
    
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator =NO;
    
    [self.itineraryView addSubview:scrollView];
}

-(void)BtnClicked:(UIButton*)sender
{
    NSString *a = [dictItinararyDetails objectForKey:@"no_of_days"];
    int no_of_days = a.intValue;
    
    for (int i = 0; i < no_of_days; i++ ) {
        UIButton *btn =[self.itineraryView viewWithTag:i+1];
        [btn setSelected:NO];
    }
    
    if (![sender isSelected])
    {
        [sender setSelected:YES];
        dayNo = [NSString stringWithFormat:@"%li", (long)sender.tag];
        
        [self itinerary_day_activity];
    } else {
        [sender setSelected:NO];
    }
    
    
    NSLog(@"button clicked on number %ld",(long)sender.tag);
    
    
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
        _descriptionView.text = @"Enter requirement";
        [_descriptionView resignFirstResponder];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itinararyDayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *inProcessIdentifier = @"ItineraryDetailCell";
    static NSString *completedIdentifier = @"ItineraryDetailCell";
    
    
    ItineraryDetailCell *cell = (ItineraryDetailCell *)[tableView dequeueReusableCellWithIdentifier:inProcessIdentifier];
    ItineraryDetailCell *cell1 = (ItineraryDetailCell *)[tableView dequeueReusableCellWithIdentifier:completedIdentifier];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItineraryDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ItineraryDetailCell" owner:self options:nil];
        cell1 = [nib1 objectAtIndex:1];
        
    }
    
    NSString *event_typeStr =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"event_type"];
    if ([event_typeStr isEqualToString:@"0"]) {
        
        cell.titleLabel.text =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        cell.addressLabel.text =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"distance"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    cell1.titleLabel.text =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell1.addressLabel.text =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"address"];
    cell1.phoneLabel.text =[NSString stringWithFormat:@"Ph.%@",[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"phoneno"]];
    cell1.descriptionLabel.text =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"description"];
    cell1.textViewheightConstraint.constant = [cell1.descriptionLabel intrinsicContentSize].height;
    NSString *dateString = [[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"reccommended_time_to_go"];
    cell1.timeLabel.text = dateString;
    
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *event_typeStr =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"event_type"];
//    if ([event_typeStr isEqualToString:@"0"]) {
//        return 65;
//    }
//    
//    return 200;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *event_typeStr =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"event_type"];
    
    NSString *sourceLat,*sourceLon,*destinationLat,*destinatinLon;
   
    if ([event_typeStr isEqualToString:@"0"])
    {
        sourceLat =[[itinararyDayArray objectAtIndex:indexPath.row-1] valueForKey:@"lat"];
        sourceLon =[[itinararyDayArray objectAtIndex:indexPath.row-1] valueForKey:@"lon"];
        destinationLat =[[itinararyDayArray objectAtIndex:indexPath.row+1] valueForKey:@"lat"];
        destinatinLon =[[itinararyDayArray objectAtIndex:indexPath.row+1] valueForKey:@"lon"];
        
        NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",[sourceLat doubleValue], [sourceLon doubleValue], [destinationLat doubleValue], [destinatinLon doubleValue]];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:@{} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL]];
        }
        
    } else {
        
        sourceLat =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"lat"];
        sourceLon =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"lon"];
        
        destinationLat =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"destination_lat"];
        destinatinLon =[[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"destination_lon"];
        
        ItinerarySectionDetailController *itinerarySection =[self.storyboard instantiateViewControllerWithIdentifier:@"ItinerarySectionDetailController"];
        itinerarySection.activityIDStr = [[itinararyDayArray objectAtIndex:indexPath.row] valueForKey:@"itinerary_activity_id"];
        itinerarySection.DirectionDict = @{@"sourceLat":sourceLat,@"sourceLon":sourceLon,@"destinationLat":destinationLat,@"destinatinLon":destinatinLon};
        [self.navigationController pushViewController:itinerarySection animated:YES];
    }
}


- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exploreCityAction:(id)sender
{
    NSLog(@"%@",dictItinararyDetails);
    
    ItinerariesCityViewController *itinerariesCity =[self.storyboard instantiateViewControllerWithIdentifier:@"ItinerariesCityViewController"];
    itinerariesCity.cityIDStr = [dictItinararyDetails valueForKey:@"city_id"];
    
    [self.navigationController pushViewController:itinerariesCity animated:YES];
    
}
- (IBAction)rateItineraryBtnAction:(id)sender
{
    
    NSLog(@"%@",self.pdfUrlStr);
    
    RateItineraryViewController *rateIntinerary =[self.storyboard instantiateViewControllerWithIdentifier:@"RateItineraryViewController"];
    rateIntinerary.itineraryDict = dictItinararyDetails;
    rateIntinerary.pdfUrlStr = self.pdfUrlStr;
    [self.navigationController pushViewController:rateIntinerary animated:YES];
    
}
- (IBAction)hideEffectViewAction:(id)sender {
    
    [self.scrollView setHidden:YES];
    [self.view endEditing:YES];
}

- (IBAction)okBtnAction:(id)sender {

    if ([self.descriptionView.text isEqualToString:@"Enter requirement"])
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     
                                     message:@"Please add some text and try again!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    } else
    {
         [self.scrollView setHidden:YES];
         [self.view endEditing:YES];
         [self changeItinerary];
        
    }
   
}
- (IBAction)requestChangeAction:(id)sender
{
    self.scrollView.frame = self.view.frame;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scrollView setHidden:NO];
}

- (IBAction)chatBtnAction:(id)sender
{
    NSLog(@"%@",dictItinararyDetails);
    
    ChatViewController *chatScreen =[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatScreen.recieverIDStr = [dictItinararyDetails valueForKey:@"local_id"];
    chatScreen.itineraryIDStr = [dictItinararyDetails valueForKey:@"itinerary_request_id"];
    [self.navigationController pushViewController:chatScreen animated:YES];
}
- (IBAction)acceptItinerary:(id)sender {
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 
                                 message:@"Are you sure you want to Accept Itinerary without changes?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [self acceptItinerary];
                                }];
    UIAlertAction* CancelBtn = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                
                                }];
    
    [alert addAction:yesButton];
    [alert addAction:CancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end

