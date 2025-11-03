//
//"ProximaNova-Extrabld",
//"ProximaNova-Regular",
//"ProximaNova-Bold",
//"ProximaNova-Light",
//"ProximaNova-Semibold"

#define  SCALE_FACTOR_H 1
#import "FontClass18.h"

@implementation FontClass18


- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (void) configurefont {
     
    self.font = [UIFont fontWithName:@"proximanova-bold-webfont1" size:18];
    
    self.textColor =  [UIColor colorWithRed:37.0f/255.0f green:36.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    
    for (NSString *fontFamilyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]) {
            NSLog(@"Font:%@", fontName);
        }
    }}



@end


