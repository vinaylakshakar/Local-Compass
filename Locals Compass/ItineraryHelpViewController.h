//
//  ItineraryHelpViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-25.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryHelpViewController : UIViewController

- (IBAction)backBtnAction:(id)sender;
- (IBAction)continueBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *QuestionTable;
@property (weak, nonatomic) IBOutlet UIView *continueView;
@property (weak, nonatomic) NSString *localIDStr;

@end
