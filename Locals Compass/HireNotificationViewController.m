//
//  HireNotificationViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "HireNotificationViewController.h"
#import "ItineraryHelpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HireNotificationViewController ()
{
    UIPickerView *daysPicker;
    NSMutableArray *daysNumberArray;
}

@end

@implementation HireNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    daysNumberArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    [self setLayout];
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
    daysPicker = [[UIPickerView alloc] init];
    [daysPicker setDataSource: self];
    [daysPicker setDelegate: self];
   // daysPicker.showsSelectionIndicator = YES;
    [self.daysNumberField setInputView:daysPicker];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.expertView.bounds byRoundingCorners: UIRectCornerBottomLeft| UIRectCornerBottomRight cornerRadii: (CGSize){5.0, 5.}].CGPath;
    
    self.expertView.layer.mask = maskLayer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - The Picker Challenge
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [daysNumberArray count];
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component{
    return daysNumberArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.daysNumberField.text = daysNumberArray[row];
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueBtnAction:(id)sender {
    
    ItineraryHelpViewController *itineraryHelp =[self.storyboard instantiateViewControllerWithIdentifier:@"ItineraryHelpViewController"];
    [self.navigationController pushViewController:itineraryHelp animated:YES];
}
@end
