//
//  QuartoBoardViewCell.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoBoardViewCell.h"
#import "UIColor+QuartoColor.h"


@interface QuartoBoardViewCell ()

@end

@implementation QuartoBoardViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor quartoGray];
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [UIColor quartoBlack].CGColor;
        self.layer.cornerRadius = self.frame.size.width / 2.f;
    }
    return self;
}

- (BOOL)canPutBoardPiece:(UIImageView *)boardPiece {
    if (self.subviews.count > 0) {
        return NO;
    }
    [self addSubview:boardPiece];
    boardPiece.userInteractionEnabled = NO;
    return YES;
}

@end