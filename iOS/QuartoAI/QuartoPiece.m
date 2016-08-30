//
//  QuartoPieces.m
//  QuartoAI
//
//  Created by Aung Moe on 8/29/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoPiece.h"
#import "NSObject+QuartoColorTemplate.h"

@implementation QuartoPiece

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [self quartoGray];
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [self quartoBlack].CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    self.layer.cornerRadius = self.frame.size.width / 6.f;
}

@end
