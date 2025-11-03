//
//  ProfileHelpViewController.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-10-03.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "ProfileHelpViewController.h"
#import <MessageUI/MessageUI.h>

@interface ProfileHelpViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation ProfileHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MFMailComposeViewControllerDelegate Methode.
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@",error.description);
            
            break;
    }
    
    // Dismiss the mail compose view controller.
    [controller dismissViewControllerAnimated:true completion:nil];
    
}


- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)contactUsAction:(id)sender {
    
    //check mail service is configure to your device or not.
    if ([MFMailComposeViewController canSendMail]) {
        
        // get a new new MailComposeViewController object
        MFMailComposeViewController * composeVC = [MFMailComposeViewController new];
        
        // his class should be the delegate of the composeVC
        [composeVC setDelegate:self];
        composeVC.mailComposeDelegate = self;
        // set a mail subject ... but you do not need to do this :)
        [composeVC setSubject:@"Help and Support!"];
        
        // set some basic plain text as the message body ... but you do not need to do this :)
        [composeVC setMessageBody:@"I want Help and Support!" isHTML:NO];
        
        // set some recipients ... but you do not need to do this :)
        [composeVC setToRecipients:[NSArray arrayWithObjects:@"support@localcompass.com", nil]];
        
        // Present the view controller modally.
        
        [self presentViewController:composeVC animated:true completion:nil];
    } else {
        
        NSLog(@"Mail services are not available or configure to your device");
    }
}
@end
