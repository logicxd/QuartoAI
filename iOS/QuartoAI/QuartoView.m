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
#import "UIColor+QuartoColor.h"


@interface QuartoView ()
@property (nonatomic, strong) NSNumber *kEdgeOffset;
@property (nonatomic, strong) NSNumber *kNameLabelWidth;
@property (nonatomic, strong) NSNumber *kNameLabelHeight;
@property (nonatomic, strong) NSNumber *kBoardSize;
@property (nonatomic, strong) NSNumber *kPieceViewWidth;
@property (nonatomic, strong) NSNumber *kPieceViewHeight;
@property (nonatomic, strong) NSNumber *kPickedPieceSize;

@property (nonatomic, strong) UILabel *nameLabel1;
@property (nonatomic, strong) UILabel *nameLabel2;
@property (nonatomic, strong) UIImageView *pickedPieceView;
@end

@implementation QuartoView

- (instancetype)init {
    if (self = [super init]) {
        // Constants. Set this to dyanmic later.
        _kEdgeOffset = @5;
        _kNameLabelWidth = @70;
        _kNameLabelHeight = @30;
        _kBoardSize = @225;
        _kPieceViewWidth = @308;
        _kPieceViewHeight = @80;
        _kPickedPieceSize = @60;
        
        // Initialize name labels;
        _nameLabel1 = [[UILabel alloc] init];
        self.nameLabel1.text = @"Player 1";
        self.nameLabel1.textAlignment = NSTextAlignmentCenter;
        self.nameLabel1.textColor = [UIColor quartoBlue];
        self.nameLabel1.backgroundColor = [UIColor clearColor];
        self.nameLabel1.layer.borderWidth = 2.0f;
        self.nameLabel1.layer.borderColor = [UIColor clearColor].CGColor;
        self.translatesAutoresizingMaskIntoConstraints = YES;
        
        _nameLabel2 = [[UILabel alloc] init];
        self.nameLabel2.text = @"Bot";
        self.nameLabel2.textAlignment = NSTextAlignmentCenter;
        self.nameLabel2.textColor = [UIColor quartoBlue];
        self.nameLabel2.backgroundColor = [UIColor clearColor];
        self.nameLabel2.layer.borderWidth = 2.0f;
        self.nameLabel2.layer.borderColor = [UIColor quartoBlue].CGColor;
        self.translatesAutoresizingMaskIntoConstraints = YES;
        
        // Initialize Board and pieces.
        _boardView = [[QuartoBoardView alloc] initWithWidth:self.kBoardSize.floatValue height:self.kBoardSize.floatValue];
        _piecesView = [[QuartoPiecesView alloc] initWithWidth:self.kPieceViewWidth.floatValue height:self.kPieceViewHeight.floatValue];
        
        // Initialize pickedPieceView.
        _pickedPieceView = [[UIImageView alloc] init];
        self.pickedPieceView.backgroundColor = [UIColor quartoGray];
        self.pickedPieceView.layer.borderWidth = 2.0f;
        self.pickedPieceView.layer.borderColor = [UIColor quartoBlack].CGColor;
        self.pickedPieceView.layer.cornerRadius = 10.f;
        self.pickedPieceView.layer.shadowOpacity = 0.5f;
        self.pickedPieceView.layer.shadowRadius = 20;
//        self.pickedPieceView.layer.shadowColor = [self quartoBlack].CGColor;
        self.pickedPieceView.translatesAutoresizingMaskIntoConstraints = YES;
        self.backgroundColor = [UIColor quartoBlack];
        
        // Add to the subviews.
        [self addSubview:self.nameLabel1];
        [self addSubview:self.nameLabel2];
        [self addSubview:self.boardView];
        [self addSubview:self.pickedPieceView];
        [self addSubview:self.piecesView];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    // iPhone 4s Width: 320. Height: 480.
    
    [self.nameLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.kNameLabelWidth);
        make.height.equalTo(self.kNameLabelHeight);
        make.top.equalTo(self).offset(self.kEdgeOffset.floatValue + 20.f);
        make.left.equalTo(self).offset(self.kEdgeOffset.floatValue);
    }];
    
    [self.nameLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.kNameLabelWidth);
        make.height.equalTo(self.kNameLabelHeight);
        make.top.equalTo(self).offset(self.kEdgeOffset.floatValue + 20.f);
        make.right.equalTo(self).offset(-self.kEdgeOffset.floatValue);
    }];
    
    [self.boardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.kBoardSize);
        make.top.equalTo(self).offset(70.f);
        make.centerX.equalTo(self);
    }];
    
    [self.pickedPieceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.kPickedPieceSize);
        make.height.equalTo(self.kPickedPieceSize);
        make.top.equalTo(self.boardView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self.piecesView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.kPieceViewWidth);
        make.height.equalTo(self.kPieceViewHeight);
        make.bottom.equalTo(self).offset(-10.f);
        make.centerX.equalTo(self);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
//    self.pickedPieceView.layer.cornerRadius = self.pickedPieceView.layer.frame.size.width / 2.f;
}

@end
