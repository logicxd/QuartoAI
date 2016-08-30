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

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [self quartoGray];
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [self quartoBlack].CGColor;
    }
    return self;
}

- (BOOL)canPutBoardPiece:(UIView *)boardPiece {
    if (self.subviews.count > 0) {
        return NO;
    }
    [self addSubview:boardPiece];
    [self.subviews.firstObject setClipsToBounds:YES];
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width / 2.f;
}

@end