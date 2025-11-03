//
//  LocalDetailViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-21.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *detailView;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)selectBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UIView *lowerView;
@property (weak, nonatomic) IBOutlet UITextView *detailtextView;
@property (weak, nonatomic) IBOutlet UIView *budgeView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak, nonatomic) IBOutlet UILabel *localName;
@property (weak, nonatomic) IBOutlet UILabel *localAddress;
@property (weak, nonatomic) IBOutlet UILabel *localYear;
@property (weak, nonatomic) IBOutlet UILabel *localExpertise;
@property (weak, nonatomic) IBOutlet UILabel *itineraryNumber;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLocalEvent;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLocalSpot;
@property (weak, nonatomic) IBOutlet UIButton *likeUnlikeBtn;
- (IBAction)localLikeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *no_of_like;
@property (weak, nonatomic) NSString *localIDStr;
@property (weak, nonatomic) IBOutlet UILabel *expertiseLable;
@end
