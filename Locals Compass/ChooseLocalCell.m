//
//  ChooseLocalCell.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-20.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ChooseLocalCell.h"

@implementation ChooseLocalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setRoundedView:self.profileImage toDiameter:70.0];
    _profileImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

@end
