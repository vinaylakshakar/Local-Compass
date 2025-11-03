//
//  ChooseCityCell.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-20.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *likeUnLikeBtn;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *cityAddress;
@property (weak, nonatomic) IBOutlet UILabel *cityLikes;
@property (weak, nonatomic) IBOutlet UILabel *cityPlansLabel;
@property (weak, nonatomic) IBOutlet UILabel *localsAvailabiltyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;


@end
