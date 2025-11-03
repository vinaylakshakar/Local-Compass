//
//  RateItineraryViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-29.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateItineraryViewController : UIViewController
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
- (IBAction)rateBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)submitRatingAction:(id)sender;

@property (strong,nonatomic) NSMutableDictionary *itineraryDict;
- (IBAction)exportPdfAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *itineraryTitle;
@property (weak, nonatomic) IBOutlet UILabel *itineraryDate;
@property (weak, nonatomic) IBOutlet UILabel *itineraryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak,nonatomic) NSString *pdfUrlStr;

@end
