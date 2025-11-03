//
//  PasswordRecoveryViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-18.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "PasswordRecoveryViewController.h"

@interface PasswordRecoveryViewController ()

@end

@implementation PasswordRecoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)passwordRecoveryAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
