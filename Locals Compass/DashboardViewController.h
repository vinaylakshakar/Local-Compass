//
//  DashboardViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-20.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *noOfMessageLabel;
- (IBAction)chooseCityBtnAction:(id)sender;
- (IBAction)chooseLocalBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *underLineView;
@property (weak, nonatomic) IBOutlet UIButton *chooseCityBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseCityLocal;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *backGroundLabel;
@property (weak, nonatomic) IBOutlet UITableView *dashboardTable;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *enRouteView;
@property (weak, nonatomic) IBOutlet UIView *thankyouView;
- (IBAction)tapOnBlurrView:(id)sender;
- (IBAction)enRouteAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)itinerariesListAction:(id)sender;
- (IBAction)profileBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)cleaseSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clearSearchBtn;

@end
