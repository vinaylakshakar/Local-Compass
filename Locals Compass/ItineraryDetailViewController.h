//
//  ItineraryDetailViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-26.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *itineraryView;
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
- (IBAction)exploreCityAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *inprocessView;
- (IBAction)rateItineraryBtnAction:(id)sender;
@property BOOL isProcess;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
- (IBAction)hideEffectViewAction:(id)sender;
- (IBAction)okBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)requestChangeAction:(id)sender;
- (IBAction)chatBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)acceptItinerary:(id)sender;
@property (weak, nonatomic) NSString *itineraryStr;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UITableView *itineraryTable;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) NSString *pdfUrlStr;

@end

