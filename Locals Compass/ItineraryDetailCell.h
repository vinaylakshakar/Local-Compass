//
//  ItineraryDetailCell.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-26.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewheightConstraint;

@end
