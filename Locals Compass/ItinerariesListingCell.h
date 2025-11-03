//
//  ItinerariesListingCell.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-26.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItinerariesListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *localsNameLable;
@property (weak, nonatomic) IBOutlet UILabel *localsCitylable;
@property (weak, nonatomic) IBOutlet UILabel *itineraryStateLable;
@property (weak, nonatomic) IBOutlet UIImageView *localImage;
@property (weak, nonatomic) IBOutlet UILabel *itineraryFromtoDate;


@end
