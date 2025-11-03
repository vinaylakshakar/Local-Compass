
//
//  ProfileNotificationViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-03.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ProfileNotificationViewController.h"

@interface ProfileNotificationViewController ()

@end

@implementation ProfileNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, self.contentView.frame.size.height)];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
