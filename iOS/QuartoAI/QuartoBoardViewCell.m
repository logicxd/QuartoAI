//
//  QuartoBoardViewCell.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoBoardViewCell.h"
#import "NSObject+QuartoColorTemplate.h"

@implementation QuartoBoardViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [self quartoBlack].CGColor;
        self.layer.cornerRadius = self.frame.size.width / 2.f;
    }
    return self;
}

@end
