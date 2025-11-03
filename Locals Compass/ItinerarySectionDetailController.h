//
//  ItinerarySectionDetailController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-28.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItinerarySectionDetailController : UIViewController
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *lowerView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
- (IBAction)getDirectionAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *sectionImage;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventAddress;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *time_to_spend;
@property (weak, nonatomic) IBOutlet UILabel *time_to_go;
@property (weak, nonatomic) NSString *activityIDStr;
@property (strong, nonatomic) NSDictionary *DirectionDict;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationHourLable;


@end
