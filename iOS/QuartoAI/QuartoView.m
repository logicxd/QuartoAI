//
//  QuartoView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoView.h"
#import "QuartoBoardView.h"
#import "QuartoPiecesView.h"
#import "Masonry.h"
#import "NSObject+QuartoColorTemplate.h"

@interface QuartoView ()
@end

@implementation QuartoView

- (instancetype)init {
    if (self = [super init]) {
        
//        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Airplane.png"]];
//        [self.imgView setUserInteractionEnabled:YES];
//         [self addSubview:self.imgView];
        
        _boardView = [[QuartoBoardView alloc] init];
        _piecesView = [[QuartoPiecesView alloc] init];
        
        self.backgroundColor = [self quartoBlack];
        [self addSubview:self.boardView];
        [self addSubview:self.piecesView];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    // iPhone 4s Width: 320. Height: 480.
    const NSNumber *kBoardSize = @225;
    const NSNumber *kPieceViewWidth = @308;
    const NSNumber *kPieceViewHeight = @80;
    
    [self.boardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(kBoardSize);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.piecesView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kPieceViewWidth);
        make.height.equalTo(kPieceViewHeight);
        make.top.equalTo(self.boardView.mas_bottom).offset(10.f);
        make.centerX.equalTo(self);
    }];
    
    [super updateConstraints];
}


@end
