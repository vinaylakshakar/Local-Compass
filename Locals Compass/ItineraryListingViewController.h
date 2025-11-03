//
//  ItineraryListingViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-26.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryListingViewController : UIViewController
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *itineraryTable;
- (IBAction)filterBtnAction:(id)sender;
- (IBAction)inProcessBtn:(id)sender;
- (IBAction)requestedBtn:(id)sender;
- (IBAction)inReviewBtn:(id)sender;
- (IBAction)completedBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectview;
- (IBAction)tapGuesture:(id)sender;
- (IBAction)clearSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clearSearchBtn;
- (IBAction)resetAll:(id)sender;

@end
