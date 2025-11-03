//
//  MessagesViewController.h
//  Locals Compass
//
//  Created by Silstone Group on 2017-09-21.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesViewController : UIViewController
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *messageTable;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end
