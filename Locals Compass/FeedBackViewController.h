//
//  FeedBackViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-03.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
- (IBAction)feedBackBtnAction:(id)sender;

@end
