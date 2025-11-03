//
//  ItineraryListingViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-26.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ItineraryListingViewController.h"
#import "ItinerariesListingCell.h"
#import "ItineraryDetailViewController.h"
#import "ChatViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface ItineraryListingViewController ()
{
    
    NSMutableArray * itinerarylistingArray;
    NSMutableArray *searchArray;
    NSString *searchTextString,*ItineraryStatusStr;
}

@end

@implementation ItineraryListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setSearch];
}

-(void)setSearch
{
    if ([self.searchField.text isEqualToString:@""])
    {
        [self.clearSearchBtn setHidden:YES];
        [self itineraryListing];
    }else
    {
        [self.clearSearchBtn setHidden:NO];
        [self updateSearchArray];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRoundedView:(UILabel *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [_searchField resignFirstResponder];
    return YES;
}

#pragma mark - Search Methods

-(void)textFieldDidChange:(UITextField*)textField
{
    searchTextString = textField.text;
    [self updateSearchArray];
    
    if ([self.searchField.text isEqualToString:@""]) {

        [self.clearSearchBtn setHidden:YES];
    }else
    {
        [self.clearSearchBtn setHidden:NO];
    }
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray
{
    if (searchTextString.length != 0) {
        searchArray = [NSMutableArray array];
        for ( NSDictionary* item in itinerarylistingArray ) {
            if ([[[item objectForKey:@"full_name"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound || [[[item objectForKey:@"CityName"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound)
            {
                [searchArray addObject:item];
            }
        }
    } else {
        searchArray = itinerarylistingArray;
    }
    
    [self.itineraryTable reloadData];
}

-(void)filterDataArray
{
    
    searchArray = [NSMutableArray array];
        
        for ( NSDictionary* item in itinerarylistingArray ) {
            if ([[[item objectForKey:@"ItineraryStatus"] lowercaseString] rangeOfString:[ItineraryStatusStr lowercaseString]].location != NSNotFound)
            {
                [searchArray addObject:item];
            }
        }
    
    [self.itineraryTable reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)itineraryListing
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"0" forKey:@"page_no"];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]itinerary_list:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             itinerarylistingArray = [[object valueForKey:@"Data"] mutableCopy];
             
             if (itinerarylistingArray.count==0) {
                 [self.itineraryTable setHidden:YES];
             }
             searchArray = itinerarylistingArray;
             [self.itineraryTable reloadData];
             
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *inProcessIdentifier = @"ItinerariesListingCell";
    static NSString *completedIdentifier = @"ItinerariesListingCell";
    static NSString *requestedIdentifier = @"ItinerariesListingCell";
    
    ItinerariesListingCell *cell = (ItinerariesListingCell *)[tableView dequeueReusableCellWithIdentifier:inProcessIdentifier];
    ItinerariesListingCell *cell1 = (ItinerariesListingCell *)[tableView dequeueReusableCellWithIdentifier:completedIdentifier];
    ItinerariesListingCell *cell2 = (ItinerariesListingCell *)[tableView dequeueReusableCellWithIdentifier:requestedIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItinerariesListingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ItinerariesListingCell" owner:self options:nil];
        cell1 = [nib1 objectAtIndex:1];
        NSArray *nib2 = [[NSBundle mainBundle] loadNibNamed:@"ItinerariesListingCell" owner:self options:nil];
        cell2 = [nib2 objectAtIndex:2];
    }
    
    NSString *status = [[searchArray objectAtIndex:indexPath.row] valueForKey:@"ItineraryStatus"];
    NSString *localNameStr =[NSString stringWithFormat:@"%@ %@.",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"FirstName"],[[[searchArray objectAtIndex:indexPath.row] valueForKey:@"LastName"] substringToIndex:1]];
    NSString *cityNameStr =[NSString stringWithFormat:@"%@, %@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"CityName"],[[searchArray objectAtIndex:indexPath.row] valueForKey:@"State"]];
    
    
    NSString *StartDate = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"StartDate"]];
    
    NSString *EndDate = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"EndDate"]];

    
    if ([status isEqualToString:@"inprogress"]||[status isEqualToString:@"inreview"]) {
        
        [self setRoundedView:cell.numberLabel toDiameter:20];
       // [self setRoundedImageView:cell.localImage toDiameter:60.0];
        
        if ([status isEqualToString:@"inprogress"]){
            cell.itineraryStateLable.text = @"In Progress";
            
        }else{
            cell.itineraryStateLable.text = @"For Review";
 
        }
        
        
        cell.numberLabel.clipsToBounds = YES;
        [cell.chatBtn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.chatBtn.tag = indexPath.row;
        cell.localsNameLable.text = localNameStr;
        cell.localsCitylable.text = cityNameStr;
        cell.itineraryFromtoDate.text =[NSString stringWithFormat:@"%@-%@",[self convertDateFormat:StartDate],[self convertDateFormat:EndDate]];
        cell.numberLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:@"ItineraryMessageNo"];
        
        NSString *profileImg = [[NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"Picture"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.localImage sd_setImageWithURL:[NSURL URLWithString:profileImg] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    if ([status isEqualToString:@"completed"]) {
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell1.localsNameLable.text = localNameStr;
        //[self setRoundedImageView:cell1.localImage toDiameter:60.0];
        cell1.localsCitylable.text = cityNameStr;
        cell1.itineraryFromtoDate.text =[NSString stringWithFormat:@"%@-%@",[self convertDateFormat:StartDate],[self convertDateFormat:EndDate]];
        [cell1.localImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"Picture"]]] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
        return cell1;
    }
    
    [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
   // [self setRoundedImageView:cell2.localImage toDiameter:60.0];
    cell2.localsNameLable.text = localNameStr;
    cell2.localsCitylable.text = cityNameStr;
    cell2.itineraryFromtoDate.text =[NSString stringWithFormat:@"%@-%@",[self convertDateFormat:StartDate],[self convertDateFormat:EndDate]];
    [cell2.localImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"Picture"]]] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
    return cell2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *status = [[itinerarylistingArray objectAtIndex:indexPath.row] valueForKey:@"ItineraryStatus"];
    
    if ([status isEqualToString:@"inreview"] || [status isEqualToString:@"completed"]) {
        
        ItineraryDetailViewController *itineraryDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryDetailViewController"];
        itineraryDetail.itineraryStr = [[itinerarylistingArray objectAtIndex:indexPath.row] valueForKey:@"ItineraryRequestId"];
        itineraryDetail.pdfUrlStr = [[itinerarylistingArray objectAtIndex:indexPath.row] valueForKey:@"pdf_url"];
        
        if ([status isEqualToString:@"inreview"]) {
            itineraryDetail.isProcess = YES;
        }
    
        [self.navigationController pushViewController:itineraryDetail animated:YES];
        
    }
    
}

-(NSString*)convertDateFormat:(NSString*)DateStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy hh:mm a"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:DateStr];
    
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *finalStartDate= [dateFormatter stringFromDate:orignalDate];
    
    return finalStartDate;
}

-(void)chatBtnClicked:(UIButton*)sender
{
    NSLog(@"you clicked on button %ld, %@", (long)sender.tag,[searchArray objectAtIndex:sender.tag]);
    ChatViewController *chat =[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chat.recieverIDStr = [[searchArray objectAtIndex:sender.tag] valueForKey:@"UserId"];
    chat.itineraryIDStr = [[searchArray objectAtIndex:sender.tag] valueForKey:@"ItineraryRequestId"];
    [self.navigationController pushViewController:chat animated:YES];
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)filterBtnAction:(id)sender {
    
    [self.effectview setHidden:NO];
}

- (IBAction)inProcessBtn:(id)sender {
    
    [self.effectview setHidden:YES];
    ItineraryStatusStr = @"inprogress";
    [self filterDataArray];
}

- (IBAction)requestedBtn:(id)sender {
    
    [self.effectview setHidden:YES];
    ItineraryStatusStr = @"new";
    [self filterDataArray];
}

- (IBAction)inReviewBtn:(id)sender {
    
    [self.effectview setHidden:YES];
    ItineraryStatusStr = @"inreview";
    [self filterDataArray];
}

- (IBAction)completedBtn:(id)sender {
    
    [self.effectview setHidden:YES];
    ItineraryStatusStr = @"completed";
    [self filterDataArray];
}
- (IBAction)tapGuesture:(id)sender {
    
    [self.effectview setHidden:YES];
}

- (IBAction)clearSearch:(id)sender {
    
    self.searchField.text =@"";
    [self setSearch];
}
- (IBAction)resetAll:(id)sender {
    
    [self.effectview setHidden:YES];
    self.searchField.text =@"";
    [self setSearch];
}
@end
