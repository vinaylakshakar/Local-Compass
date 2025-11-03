//
//  HeadingLabelClass.m
//  TribesApp
//
//  Created by ashan deep on 4/20/17.
//  Copyright © 2017 SilstoneGroup. All rights reserved.
//
//#define  SCALE_FACTOR_H ( [UIScreen mainScreen].bounds.size.height / 568 )
#define  SCALE_FACTOR_H 1
#import "HeadingLabelClass.h"

@implementation HeadingLabelClass

- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (void) configurefont {
    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:18];
   // self.font = [UIFont systemFontOfSize:40];
   self.textColor =  [UIColor blackColor];
}
@end
