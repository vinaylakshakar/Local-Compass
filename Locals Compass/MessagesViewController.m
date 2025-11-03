//
//  MessagesViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-21.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesCell.h"
#import "NetworkEngine.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"

@interface MessagesViewController ()
{
    NSMutableArray *messagesArray;
    NSMutableArray *searchArray;
    NSString *searchTextString;
}

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
[self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self user_message];
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [_searchField resignFirstResponder];
    return YES;
}

-(void)user_message
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"userId"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]user_message:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             messagesArray = [[object valueForKey:@"Data"] mutableCopy];
             
             NSInteger totalMessages = 0;
             for (NSMutableDictionary *dict in messagesArray) {
                 
                 if (![[dict valueForKey:@"sender_id"] isEqualToString:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"]])
                 {
                     NSInteger messageNo = [[dict valueForKey:@"unread_message"] integerValue];
                     totalMessages = totalMessages + messageNo;
                 }
                 
                
             }
             
             NSString *totalUnreadMessage = [NSString stringWithFormat:@"%ld",(long)totalMessages];
             
             [USERDEFAULTS setObject:totalUnreadMessage forKey:UnreadMessages];
             searchArray = messagesArray;
              [self.messageTable reloadData];
             
         } else
         {
             [self.messageTable setHidden:YES];
            
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

#pragma mark - Search Methods

-(void)textFieldDidChange:(UITextField*)textField
{
    searchTextString = textField.text;
    [self updateSearchArray];
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray
{
    if (searchTextString.length != 0) {
        searchArray = [NSMutableArray array];
        for ( NSDictionary* item in messagesArray ) {
            if ([[[item objectForKey:@"FirstName"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound)
            {
                [searchArray addObject:item];
            }
        }
    } else {
        searchArray = messagesArray;
    }
    
    [self.messageTable reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MessagesCell";
    static NSString *propertyIdentifier = @"MessagesCell";
    
    MessagesCell *cell = (MessagesCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    MessagesCell *cell1 = (MessagesCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessagesCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"MessagesCell" owner:self options:nil];
        cell1 = [nib1 objectAtIndex:1];
    }
    
    if ([[[searchArray objectAtIndex:indexPath.row]valueForKey:@"status"] isEqualToString:@"0"] || [[[searchArray objectAtIndex:indexPath.row]valueForKey:@"sender_id"] isEqualToString:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"]]) {
        
        cell1.sendarNameWithTime.text =[NSString stringWithFormat:@"%@", [[searchArray objectAtIndex:indexPath.row] valueForKey:@"messageTime"]];
        
        
        if ([[[searchArray objectAtIndex:indexPath.row]valueForKey:@"sender_id"] isEqualToString:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"]])
        {
             cell1.messageTitle.text = @"You";
        } else {
             cell1.messageTitle.text = [NSString stringWithFormat:@"%@ %@.",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"FirstName"], [[[searchArray objectAtIndex:indexPath.row]valueForKey:@"LastName"] substringToIndex:1]];
        }
        
       
        cell1.messageText.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:@"message"];
        [cell1.sendarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"Picture"]]] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
        [self setRoundedImageView:cell.sendarImage toDiameter:35.0];
        cell1.sendarImage.clipsToBounds = YES;
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell1;
        
       
    }

    cell.sendarNameWithTime.text =[NSString stringWithFormat:@"%@", [[searchArray objectAtIndex:indexPath.row] valueForKey:@"messageTime"]];
    
    if ([[[searchArray objectAtIndex:indexPath.row]valueForKey:@"sender_id"] isEqualToString:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"]])
    {
            cell.messageTitle.text = @"You";
    } else {
            cell.messageTitle.text = [NSString stringWithFormat:@"%@ %@.",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"FirstName"], [[[searchArray objectAtIndex:indexPath.row]valueForKey:@"LastName"] substringToIndex:1]];
    }
    
    
    cell.messageText.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:@"message"];

    [cell.sendarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] valueForKey:@"Picture"]]] placeholderImage:[UIImage imageNamed:@"no_image"] options:0 progress:nil completed:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setRoundedImageView:cell.sendarImage toDiameter:35.0];
    cell1.sendarImage.clipsToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[searchArray objectAtIndex:indexPath.row]);
    
    ChatViewController *chatScreen =[self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatScreen.recieverIDStr = [[searchArray objectAtIndex:indexPath.row] valueForKey:@"receiver_id"];
    chatScreen.itineraryIDStr = [[searchArray objectAtIndex:indexPath.row] valueForKey:@"itineraryid"];
    [self.navigationController pushViewController:chatScreen animated:YES];
    
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
