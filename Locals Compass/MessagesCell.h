//
//  MessagesCell.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-21.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *sendarNameWithTime;
@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UIImageView *sendarImage;

@end
