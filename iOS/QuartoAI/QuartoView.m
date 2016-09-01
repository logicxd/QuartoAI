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
@property (nonatomic, strong) NSNumber *kBoardSize;
@property (nonatomic, strong) NSNumber *kPieceViewWidth;
@property (nonatomic, strong) NSNumber *kPieceViewHeight;
@end

@implementation QuartoView

- (instancetype)init {
    if (self = [super init]) {
        // Constants. Set this to dyanmic later.
        _kBoardSize = @225;
        _kPieceViewWidth = @308;
        _kPieceViewHeight = @80;
        
        // Initialize Board and pieces.
        _boardView = [[QuartoBoardView alloc] initWithWidth:self.kBoardSize.floatValue height:self.kBoardSize.floatValue];
        _piecesView = [[QuartoPiecesView alloc] initWithWidth:self.kPieceViewWidth.floatValue height:self.kPieceViewHeight.floatValue];
        
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
    [self.boardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.kBoardSize);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.piecesView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.kPieceViewWidth);
        make.height.equalTo(self.kPieceViewHeight);
        make.top.equalTo(self.boardView.mas_bottom).offset(10.f);
        make.centerX.equalTo(self);
    }];
    
    [super updateConstraints];
}


@end
