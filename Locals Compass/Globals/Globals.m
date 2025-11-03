//
//  Globals.m
//  Locals Compass
//
//  Created by Silstone Group on 2017-08-22.
//  Copyright © 2017 Silstone Group. All rights reserved.
//

#import "Globals.h"
#import "ViewController.h"

@implementation Globals

+ (void)AddAlert:(NSString *)alertTitle Message:(NSString *)message View:(UIViewController *)viewCon{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:alertTitle
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btn_Done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
       
        NSLog(@"you pressed Yes, please button");
        
    }];
    
    [alert addAction:btn_Done];

    [viewCon presentViewController:alert animated:YES completion:nil];
}
    
@end
