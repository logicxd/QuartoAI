//
//  UIColor+QuartoColor.m
//  QuartoAI
//
//  Created by Aung Moe on 9/2/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "UIColor+QuartoColor.h"

@implementation UIColor (QuartoColor)

+ (UIColor *)quartoRed {
    return [UIColor colorWithRed:194/255.f green:91/255.f blue:86/255.f alpha:1];
}

+ (UIColor *)quartoWhite {
    return [UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1];
}

+ (UIColor *)quartoBlack {
    return [UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1];
}

+ (UIColor *)quartoBlue {
    return [UIColor colorWithRed:150/255.f green:192/255.f blue:206/255.f alpha:1];
}

+ (UIColor *)quartoGray {
    return [UIColor colorWithHue:209/359.f saturation:19/100.f brightness:56/100.f alpha:1];
}

+ (UIColor *)quartoBoardColor {
//    return [UIColor colorWithRed:90/255.f green:17/255.f blue:9/255.f alpha:1];
    return [UIColor colorWithRed:92/255.f green:30/255.f blue:30/255.f alpha:1];
}

@end
