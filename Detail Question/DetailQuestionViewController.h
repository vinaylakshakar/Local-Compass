//
//  DetailQuestionViewController.h
//  Locals Compass
//
//  Created by Silstone on 10/11/17.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailQuestionViewController : UIViewController
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak,nonatomic) NSString *questionTypeStr;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *selectBoolView;
@property (weak, nonatomic) IBOutlet UIView *detailAnswerView;
@property (weak, nonatomic) IBOutlet UIPickerView *numberPickerView;
@property NSInteger inedxNumber;
@property (weak, nonatomic) NSMutableArray *questionArray;
- (IBAction)okBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *optionFirstLable;
@property (weak, nonatomic) IBOutlet UILabel *optionSecondLable;
- (IBAction)optionFirstAction:(id)sender;
- (IBAction)optionSecondAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *optionFirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *optionSecondBtn;
- (IBAction)valueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *selectPriceRangeView;
@property (weak, nonatomic) IBOutlet UILabel *priceFirstRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceSecondRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceThirdRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceFourthRangeLabel;
- (IBAction)selectPriceRangeAction:(id)sender;

@end
