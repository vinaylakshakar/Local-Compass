//
//  CityDetailsViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-21.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *cityDetailTextView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *lowerView;
@property (weak, nonatomic) IBOutlet UILabel *labelAvailabiltiy;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPlans;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLocals;
@property (weak, nonatomic) IBOutlet UILabel *populationLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestTimeToGoLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowSeasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *heighSeasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *passportRequirementLable;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UIButton *likeUnlikeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
- (IBAction)cityLikeAction:(id)sender;

@property (weak, nonatomic) NSString *cityIDStr;

@end
