//
//  SubmitRequestViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "SubmitRequestViewController.h"
#import "FinishViewController.h"

@interface SubmitRequestViewController ()

@end

@implementation SubmitRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//Rajat Code Start.....
-(void)sendUserRequest{
    
}
//Rajat Code End.....
- (IBAction)continueBtnAction:(id)sender {
    
    FinishViewController *finish =[self.storyboard instantiateViewControllerWithIdentifier:@"FinishViewController"];
    [self.navigationController pushViewController:finish animated:YES];
}
@end
