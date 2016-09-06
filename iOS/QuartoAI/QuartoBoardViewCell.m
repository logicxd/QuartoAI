//
//  QuartoBoardViewCell.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoBoardViewCell.h"
#import "QuartoPiece.h"
#import "UIColor+QuartoColor.h"


@interface QuartoBoardViewCell ()
@property (nonatomic, strong, readwrite) NSNumber *pieceIndex;
@end

@implementation QuartoBoardViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor quartoBlack].CGColor;
        self.layer.cornerRadius = self.frame.size.width / 2.f;
    }
    return self;
}

- (BOOL)putBoardPiece:(QuartoPiece *)boardPiece {
    if ([self hasBoardPiece]) {
        return NO;
    }
    _pieceIndex = boardPiece.pieceIndex;
    UIImageView *boardImage = [[UIImageView alloc] initWithImage:boardPiece.image];
    boardImage.frame = CGRectMake(0, 0,boardPiece.frame.size.width, boardPiece.frame.size.height);
    boardImage.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    [self addSubview:boardImage];
    return YES;
}

- (BOOL)hasBoardPiece {
    if (self.subviews.count > 0) {
        return YES;
    }
    return NO;
}

@end