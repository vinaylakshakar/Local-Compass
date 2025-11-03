//
//  ItineraryHelpViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-25.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ItineraryHelpViewController.h"
#import "DetailQuestionViewController.h"
#import "ItineraryQuestionCell.h"
#import "NetworkEngine.h"
#import "Constants.h"

@interface ItineraryHelpViewController ()
{
    NSMutableArray *ItineraryQuestionArray;
    UIPickerView *firstPicker,*secondPicker,*thirdPicker;
    BOOL isAnswered;
}

@end

@implementation ItineraryHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLayout];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    isAnswered =YES;
    NSLog(@"%@",ItineraryQuestionArray);
   [self.QuestionTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLayout
{
    [self getItineraryQuestion];
    //self.QuestionTable.tableFooterView = self.continueView;
}

-(void)getItineraryQuestion
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.localIDStr forKey:@"local_id"];
    
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]get_question:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             ItineraryQuestionArray = [[object valueForKey:@"Data"] mutableCopy];
             [self.QuestionTable reloadData];
             
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ItineraryQuestionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *objectiveQuestion = @"ItineraryQuestionCell";
    
    
    ItineraryQuestionCell *cell = (ItineraryQuestionCell *)[tableView dequeueReusableCellWithIdentifier:objectiveQuestion];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItineraryQuestionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        
    }
    
    cell.questionLabel.text =[[ItineraryQuestionArray objectAtIndex:indexPath.row] valueForKey:@"question"];
    
    cell.answerField.placeholder = [[ItineraryQuestionArray objectAtIndex:indexPath.row] valueForKey:@"question_placeholder"];
    if ([[ItineraryQuestionArray objectAtIndex:indexPath.row] valueForKey:@"answer"])
    {
        cell.answerField.text = [[ItineraryQuestionArray objectAtIndex:indexPath.row] valueForKey:@"answer"];
    }else if ([[[ItineraryQuestionArray objectAtIndex:indexPath.row] valueForKey:@"question_type"] isEqualToString:@"1"])
    {
        cell.answerField.text = @"";
    }else
    {
        isAnswered = NO;
    }
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailQuestionViewController *detailQuestion=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailQuestionViewController"];
    detailQuestion.questionTypeStr = [[ItineraryQuestionArray objectAtIndex:indexPath.row] valueForKey:@"question_type"];
    detailQuestion.inedxNumber =indexPath.row;
    detailQuestion.questionArray =ItineraryQuestionArray;
    [self presentViewController:detailQuestion animated:YES completion:nil];
}


- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SubmitItinerary
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"user_id"];
    [dict setObject:self.localIDStr forKey:@"local_id"];
    
    NSError* error = nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:ItineraryQuestionArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    
    [dict setObject:jsonString forKey:@"submit_request"];
    
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        //[dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceId"];
        
    }
    else{
        // [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceId"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]itinerary_submit:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"Response"] isEqualToString:@"success"])
         {
             
             ItineraryQuestionArray = [[object valueForKey:@"Data"] mutableCopy];
 
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:nil
                                          
                                          message:[object valueForKey:@"Message"]
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

- (IBAction)continueBtnAction:(id)sender {
    
    NSLog(@"%id",isAnswered);
    
    if (isAnswered==NO) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     
                                     message:@"Please answer all questions"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    } else {

        [self SubmitItinerary];
    }
    

}
@end
