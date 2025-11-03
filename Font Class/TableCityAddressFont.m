//
//"ProximaNova-Extrabld",
//"ProximaNova-Regular",
//"ProximaNova-Bold",
//"ProximaNova-Light",
//"ProximaNova-Semibold"

#define  SCALE_FACTOR_H 1
#import "TableCityAddressFont.h"

@implementation TableCityAddressFont


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
    
    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:13];
    
    self.textColor =  [UIColor colorWithRed:0.20 green:0.77 blue:0.94 alpha:1.0];
    
    
}



@end


