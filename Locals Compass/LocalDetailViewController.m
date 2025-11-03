//
//  LocalDetailViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-21.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "LocalDetailViewController.h"
#import "HireNotificationViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "ItineraryHelpViewController.h"

@interface LocalDetailViewController ()
{
    
    NSMutableDictionary *localProfileDict,*likeUnlikeDict;
}

@end

@implementation LocalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self setLayout];
    [self getLocalProfile];
    [self setRoundedView:self.profileImage toDiameter:100.0];
    _profileImage.clipsToBounds = YES;
    [_profileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [_profileImage.layer setBorderWidth: 5.0];
    
    
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

-(void)setLayout
{
    
    
    self.localName.text = [NSString stringWithFormat:@"%@ %@.",[localProfileDict valueForKey:@"first_name"],[[localProfileDict valueForKey:@"last_name"] substringToIndex:1]];
    self.localYear.text = [NSString stringWithFormat:@"%@ Years as a local",[localProfileDict valueForKey:@"years_as_local"]];
    self.localAddress.text = [NSString stringWithFormat:@"%@, %@",[localProfileDict valueForKey:@"city_name"],[localProfileDict valueForKey:@"state"]];
    self.localExpertise.text = [localProfileDict valueForKey:@"expertise_as_local"];
    self.expertiseLable.text =[NSString stringWithFormat:@"Expertise: %@",self.localExpertise.text];
    self.detailtextView.text = [localProfileDict valueForKey:@"description"];
    self.favouriteLocalEvent.text = [localProfileDict valueForKey:@"fav_local_event"];
    self.favouriteLocalSpot.text = [localProfileDict valueForKey:@"fav_local_spot"];
    self.no_of_like.text = [localProfileDict valueForKey:@"no_of_like"];
    self.itineraryNumber.text = [localProfileDict valueForKey:@"no_of_itinerary"];
    NSString *islikedStr = [localProfileDict valueForKey:@"is_liked"];
    
    if ([islikedStr isEqualToString:@"1"]) {
        [self.likeUnlikeBtn setSelected:YES];
    }

     NSString *budgeNumber = [localProfileDict valueForKey:@"badge_id"];
    
    for (int i =1; i<= [budgeNumber intValue]; i++) {
        
        UIButton *btn =(UIButton *)[self.view viewWithTag:i+10];
        [btn setSelected:YES];
    }
    
     NSString *profileImg = [[NSString stringWithFormat:@"%@",[localProfileDict valueForKey:@"picture"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   [self.profileImage sd_setImageWithURL:[NSURL URLWithString:profileImg] placeholderImage:nil options:0 progress:nil completed:nil];
   [self.cityImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[localProfileDict valueForKey:@"city_image"]]] placeholderImage:nil options:0 progress:nil completed:nil];
    
    [self.detailtextView sizeToFit];
    
    NSLog(@"%f",self.detailtextView.frame.size.height);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height > 568)
        {
            // iPhone >5
            if (self.detailtextView.frame.size.height>250)
            {
                self.detailtextView.frame = CGRectMake(0, self.detailtextView.frame.origin.y, self.view.frame.size.width, self.detailtextView.frame.size.height-70);
            }else
            {
                self.detailtextView.frame = CGRectMake(0, self.detailtextView.frame.origin.y, self.view.frame.size.width, self.detailtextView.frame.size.height);
            }
        }else
        {
            if (self.detailtextView.frame.size.height>70)
            {
                self.detailtextView.frame = CGRectMake(0, self.detailtextView.frame.origin.y, self.view.frame.size.width, self.detailtextView.frame.size.height-5);
            }else
            {
                self.detailtextView.frame = CGRectMake(0, self.detailtextView.frame.origin.y, self.view.frame.size.width, self.detailtextView.frame.size.height);
            }
            
        }
    }
    
//    if (self.detailtextView.frame.size.height>70)
//    {
//           self.detailtextView.frame = CGRectMake(0, self.detailtextView.frame.origin.y, self.view.frame.size.width, self.detailtextView.frame.size.height-5);
//    }else
//    {
//        self.detailtextView.frame = CGRectMake(0, self.detailtextView.frame.origin.y, self.view.frame.size.width, self.detailtextView.frame.size.height);
//    }
 
    self.upperView.frame = CGRectMake(self.upperView.frame.origin.x, self.upperView.frame.origin.y, self.view.frame.size.width, self.upperView.frame.size.height);
    self.lowerView.frame = CGRectMake(self.lowerView.frame.origin.x, self.detailtextView.frame.origin.y+self.detailtextView.frame.size.height-15, self.view.frame.size.width, self.lowerView.frame.size.height);
    self.budgeView.frame = CGRectMake(self.budgeView.frame.origin.x, self.lowerView.frame.origin.y+self.lowerView.frame.size.height+14, self.view.frame.size.width, self.budgeView.frame.size.height);
    self.detailView.frame = CGRectMake(self.detailView.frame.origin.x, self.detailView.frame.origin.y, self.view.frame.size.width, self.budgeView.frame.origin.y + self.budgeView.frame.size.height+10);
    
    [_scrollview setContentSize:CGSizeMake(_scrollview.frame.size.width, self.detailView.frame.size.height)];
    
    [self.detailView setHidden:NO];
}

-(void)getLocalProfile
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.localIDStr forKey:@"localId"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userID"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]get_local_profile:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             localProfileDict = [[[object valueForKey:@"Data"] objectAtIndex:0]  mutableCopy];
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

-(void)localLike
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.localIDStr  forKey:@"localId"];
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
    
    [[NetworkEngine sharedNetworkEngine]local_like:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             likeUnlikeDict = [[[object valueForKey:@"Data"] objectAtIndex:0]  mutableCopy];
             self.no_of_like.text = [likeUnlikeDict valueForKey:@"No_Of_Likes"];
             
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


- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectBtnAction:(id)sender {
    
    ItineraryHelpViewController *ItineraryHelp =[self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryHelpViewController"];
    ItineraryHelp.localIDStr = self.localIDStr;
    [self.navigationController pushViewController:ItineraryHelp animated:YES];
}
- (IBAction)localLikeAction:(id)sender {
    
    [self localLike];
}
@end
