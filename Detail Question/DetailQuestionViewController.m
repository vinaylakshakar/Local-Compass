//
//  DetailQuestionViewController.m
//  Locals Compass
//
//  Created by Silstone on 10/11/17.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "DetailQuestionViewController.h"
#import "SelectMultipleCell.h"

@interface DetailQuestionViewController ()
{
    
    NSArray *selectMultipleArray;
    NSMutableArray *selectedArray,*dataArray;
    NSString *AnswerStr;
    NSInteger priceIndex;
}

@end

@implementation DetailQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    selectMultipleArray = [[NSMutableArray alloc]init];
    selectedArray = [[NSMutableArray alloc]init];
    dataArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //NSLog(@"testing Done");
    // Do any additional setup after loading the view.
    [self setLayout];
    self.datePickerView.minimumDate = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView ==_detailTextView) {
        _detailTextView.text = @"";
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(_detailTextView.text.length == 0){
        _detailTextView.text = @"Enter Description";
        [_detailTextView resignFirstResponder];
    }
}

-(void)createSelectionArray
{
    selectMultipleArray = [[[self.questionArray objectAtIndex:self.inedxNumber] valueForKey:@"question_placeholder"] componentsSeparatedByString: @","];
    [self.tableView reloadData];
}

-(void)selectOption
{
    selectMultipleArray = [[[self.questionArray objectAtIndex:self.inedxNumber] valueForKey:@"question_placeholder"] componentsSeparatedByString: @","];
    if (selectMultipleArray.count>2)
    {
        [self.selectPriceRangeView setHidden:NO];
        [self selectFromFourOption];
    } else {
        [self.selectBoolView setHidden:NO];
        [self selectFromTwoOption];
    }

}

-(void)selectFromTwoOption
{
    [self.optionFirstLable setText:[selectMultipleArray objectAtIndex:0]];
    [self.optionSecondLable setText:[selectMultipleArray objectAtIndex:1]];
}

-(void)selectFromFourOption
{
    [self.priceFirstRangeLabel setText:[[selectMultipleArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [self.priceSecondRangeLabel setText:[[selectMultipleArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [self.priceThirdRangeLabel setText:[[selectMultipleArray objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    [self.priceFourthRangeLabel setText:[[selectMultipleArray objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

-(void)setLayout
{
    switch ([self.questionTypeStr integerValue]) {
        case 1:
            [self.detailAnswerView setHidden:NO];
            break;
        case 2:
            [self.tableView setHidden:NO];
            [self createSelectionArray];
            break;
        case 3:
            [self.tableView setHidden:NO];
            [self createSelectionArray];
            break;
        case 4:
            //[self.selectBoolView setHidden:NO];
            [self selectOption];
            break;
        case 5:
            [self.detailAnswerView setHidden:NO];
            break;
        case 6:
            [self.datePickerView setHidden:NO];
            break;
        case 7:
            [self.datePickerView setHidden:NO];
            break;
        case 8:
             [self.tableView setHidden:NO];
             [self createSelectionArray];
            break;
        case 9:
             [self.numberPickerView setHidden:NO];
            break;
        default:
            break;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//pickerview delegate-
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //Return the number of components
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //Return the number of rows in the component
    return 7;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    AnswerStr = [dataArray objectAtIndex:row];
}

//tableview delegate-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectMultipleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *objectiveQuestion = @"SelectMultipleCell";
    
    
    SelectMultipleCell *cell = (SelectMultipleCell *)[tableView dequeueReusableCellWithIdentifier:objectiveQuestion];
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectMultipleCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        
    }
    
    cell.optionLable.text =[selectMultipleArray objectAtIndex:indexPath.row];
    cell.btnSelected.tag = indexPath.row;
    
    if ([selectedArray containsObject:cell.optionLable.text]) {
        // do something
        [cell.btnSelected setSelected:YES];
    }

    [cell.btnSelected addTarget:self action:@selector(SelectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)SelectButtonTapped:(UIButton*)sender
{
    NSIndexPath *indexPath= [NSIndexPath indexPathForRow:sender.tag inSection:0];
    SelectMultipleCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];

    
    if (![cell.btnSelected isSelected]) {
        [cell.btnSelected setSelected:YES];
        
        [selectedArray addObject:[selectMultipleArray objectAtIndex:sender.tag]];
        //[selectedArray insertObject:[selectMultipleArray objectAtIndex:sender.tag] atIndex:sender.tag];
    } else {
        [cell.btnSelected setSelected:NO];
        
         NSUInteger indexValue = [selectedArray indexOfObject:[selectMultipleArray objectAtIndex:sender.tag]];
        
        if (indexValue||indexValue==0) {
             [selectedArray removeObjectAtIndex:indexValue];
        }
        
       
    }
 
}


- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)okBtnAction:(id)sender {
    
    NSMutableDictionary *QuestionDict =[[NSMutableDictionary alloc]initWithDictionary:[self.questionArray objectAtIndex:self.inedxNumber]];

    
    

    
        if ([self.questionTypeStr isEqualToString:@"4"])
        {

            if (selectMultipleArray.count>2)
            {
                  AnswerStr = [selectMultipleArray objectAtIndex:priceIndex];
            } else
            {
                if ([self.optionFirstBtn isSelected])
                {
                    AnswerStr = [selectMultipleArray objectAtIndex:0];
                }
                if ([self.optionSecondBtn isSelected])
                {
                    AnswerStr = [selectMultipleArray objectAtIndex:1];
                }
            }
            
            
        }
        
        if ([self.questionTypeStr isEqualToString:@"2"]||[self.questionTypeStr isEqualToString:@"3"]||[self.questionTypeStr isEqualToString:@"8"])
        {
            AnswerStr =[selectedArray componentsJoinedByString:@","];
            
        }
        
        if ([self.questionTypeStr isEqualToString:@"1"]||[self.questionTypeStr isEqualToString:@"5"])
        {
            AnswerStr =self.detailTextView.text;
            
        }
        
        if ([self.questionTypeStr isEqualToString:@"6"]||[self.questionTypeStr isEqualToString:@"7"])
        {
            
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//            [dateFormat setDateFormat:@"MMMM dd, yyyy hh:mm a"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMMM dd, yyyy hh:mm a"];
            // NSString *date = [dateFormat stringFromDate:datePicker.date];
            
            AnswerStr = [dateFormat stringFromDate:self.datePickerView.date];
            
        }
        
        if ([self.questionTypeStr isEqualToString:@"9"]&& AnswerStr.length == 0) {
            
            AnswerStr= @"1";
        }
    
    if (AnswerStr == (id)[NSNull null] || AnswerStr.length == 0)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:nil
                                     
                                     message:@"Please Answer the Question."
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
        
        [QuestionDict setObject:AnswerStr forKey:@"answer"];
        
        [self.questionArray replaceObjectAtIndex:self.inedxNumber withObject:QuestionDict];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
        

}
- (IBAction)optionFirstAction:(id)sender {
    
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [self.optionSecondBtn setSelected:NO];
    } else {
        [sender setSelected:NO];
    }
}

- (IBAction)optionSecondAction:(id)sender {
    
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [self.optionFirstBtn setSelected:NO];
    } else {
        [sender setSelected:NO];
    }
}
- (IBAction)valueChanged:(id)sender {
    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm a"];
    // NSString *date = [dateFormat stringFromDate:datePicker.date];
    
    AnswerStr = [dateFormat stringFromDate:self.datePickerView.date];
}
- (IBAction)selectPriceRangeAction:(id)sender {
    
    for (int tag=11; tag<=14; tag++) {
        UIButton *btn =[self.view viewWithTag:tag];
        [btn setSelected:NO];
    }
    
    priceIndex = [sender tag]-11;
    UIButton *btn =[self.view viewWithTag:[sender tag]];
    [btn setSelected:YES];
}
@end
