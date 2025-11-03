//
//"ProximaNova-Extrabld",
//"ProximaNova-Regular",
//"ProximaNova-Bold",
//"ProximaNova-Light",
//"ProximaNova-Semibold"

#define  SCALE_FACTOR_H 1
#import "FontClass11.h"

@implementation FontClass11


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
    // CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
//    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:24];
//    
//    CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
    
    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:12];
    
    self.textColor =  [UIColor colorWithRed:37.0f/255.0f green:36.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    
    
}



@end

