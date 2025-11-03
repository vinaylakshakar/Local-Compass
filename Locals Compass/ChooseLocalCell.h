//
//  ChooseLocalCell.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-20.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLocalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *localNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *itineraryNumber;
@property (weak, nonatomic) IBOutlet UILabel *budgetNumber;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *likeUnlikeBtn;

@end
