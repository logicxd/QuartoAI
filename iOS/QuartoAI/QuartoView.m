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
#import "QuartoPiece.h"
#import "QuartoSettingsView.h"
#import "Masonry.h"
#import "UIColor+QuartoColor.h"
#import "CustomIOSAlertView.h"

@interface QuartoView ()
@property (nonatomic, assign) CGSize kScreenSize;
@property (nonatomic, strong) NSNumber *kEdgeOffset;
@property (nonatomic, strong) NSNumber *kNameLabelWidth;
@property (nonatomic, strong) NSNumber *kNameLabelHeight;
@property (nonatomic, strong) NSNumber *kSettingsSize;
@property (nonatomic, strong) NSNumber *kBoardSize;
@property (nonatomic, strong) NSNumber *kPickedPieceSize;
@property (nonatomic, strong) NSNumber *kPieceViewWidth;
@property (nonatomic, strong) NSNumber *kPieceViewHeight;
@end

@implementation QuartoView

- (instancetype)initWithFirstPlayerName:(NSString *)firstPlayerName secondPlayerName:(NSString *)secondPlayerName {
    if (self = [super init]) {
        
        // Constants. Set this to dyanmic later?
        _kEdgeOffset = @5;
        _kNameLabelWidth = @70;
        _kNameLabelHeight = @30;
        _kSettingsSize = @18;
        _kBoardSize = @225;
        _kPickedPieceSize = @50;
        _kPieceViewWidth = @308;
        _kPieceViewHeight = @80;
        
        // Add the settings button.
        _settingsButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        self.settingsButton.tintColor = [UIColor quartoBlue];
        self.settingsButton.layer.shadowOpacity = .5f;
        self.settingsButton.layer.shadowRadius = 1;
        self.settingsButton.layer.shadowOffset = CGSizeMake(0, 6);
        [self.settingsButton setImage:[UIImage imageNamed:@"Settings-50.png"] forState:UIControlStateNormal];
        [self.settingsButton addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        
        // Initialize SettingsView.
        _settingsView = [[QuartoSettingsView alloc] init];
        
        // Initialize CustomIOSAlertView.
        _customIOSAlertView = [[CustomIOSAlertView alloc] init];
        [self.customIOSAlertView setButtonTitles:nil];
        [self.customIOSAlertView setCloseOnTouchUpOutside:YES];
        [self.customIOSAlertView setContainerView:self.settingsView];
        
        // Initialize name labels.
        _nameLabel1 = [[UILabel alloc] init];
        self.nameLabel1.text = firstPlayerName;
        self.nameLabel1.textAlignment = NSTextAlignmentCenter;
        self.nameLabel1.textColor = [UIColor quartoBlue];
        self.nameLabel1.backgroundColor = [UIColor clearColor];
        self.nameLabel1.layer.borderWidth = 2.0f;
        self.nameLabel1.layer.borderColor = [UIColor clearColor].CGColor;
        self.nameLabel1.translatesAutoresizingMaskIntoConstraints = YES;
        
        _nameLabel2 = [[UILabel alloc] init];
        self.nameLabel2.text = secondPlayerName;
        self.nameLabel2.textAlignment = NSTextAlignmentCenter;
        self.nameLabel2.textColor = [UIColor quartoBlue];
        self.nameLabel2.backgroundColor = [UIColor clearColor];
        self.nameLabel2.layer.borderWidth = 2.0f;
        self.nameLabel2.layer.borderColor = [UIColor clearColor].CGColor;
        self.nameLabel2.translatesAutoresizingMaskIntoConstraints = YES;
        
        // Initialize board view and pieces view.
        _boardView = [[QuartoBoardView alloc] initWithWidth:self.kBoardSize.floatValue height:self.kBoardSize.floatValue];
        _piecesView = [[QuartoPiecesView alloc] initWithWidth:self.kPieceViewWidth.floatValue height:self.kPieceViewHeight.floatValue];
        
        // Initialize pickedPieceView.
        _pickedPieceView = [[UIView alloc] init];
        self.pickedPieceView.backgroundColor = [UIColor quartoGray];
        self.pickedPieceView.layer.cornerRadius = 5.f;
        self.pickedPieceView.layer.shadowOpacity = .5f;
        self.pickedPieceView.layer.shadowRadius = 1;
        self.pickedPieceView.layer.shadowOffset = CGSizeMake(0, 6);
        self.pickedPieceView.translatesAutoresizingMaskIntoConstraints = YES;
        
        // Settings for this view.
        self.backgroundColor = [UIColor quartoBlack];
        
        // Add views as subviews.
        [self addSubview:self.settingsButton];
        [self addSubview:self.nameLabel1];
        [self addSubview:self.nameLabel2];
        [self addSubview:self.boardView];
        [self addSubview:self.pickedPieceView];
        [self addSubview:self.piecesView];
    }
    return self;
}

#pragma mark - Button Hit

- (void)buttonHit:(UIButton *)button {
    
    if (button == self.settingsButton) {
        NSLog(@"\"Settings\" is pressed");
        [self.customIOSAlertView show];
    }
}

#pragma mark - PickedPieceView Methods

- (BOOL)putBoardPieceIntoPickedPieceView:(QuartoPiece *)quartoPiece {
    if ([self hasAPieceInPickedPieceView]) {
        return NO;
    }
    
    _pickedPieceViewIndex = quartoPiece.pieceIndex;
    quartoPiece.center = CGPointMake(self.pickedPieceView.frame.size.width/2.f,
                                     self.pickedPieceView.frame.size.width/2.f);
    [self.pickedPieceView addSubview:quartoPiece];
    return YES;
}

- (void)removePieceFromPickedPieceView {
    for (UIView *eachView in self.pickedPieceView.subviews) {
        [eachView removeFromSuperview];
    }
}

- (BOOL)hasAPieceInPickedPieceView {
    if (self.pickedPieceView.subviews.count > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Constraints

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
        make.top.equalTo(self.nameLabel1);
        make.right.equalTo(self).offset(-self.kEdgeOffset.floatValue);
    }];
    
    [self.settingsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.kSettingsSize);
        make.centerY.equalTo(self.nameLabel1);
        make.centerX.equalTo(self);
    }];
    
    [self.boardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.kBoardSize);
        make.top.equalTo(self).offset(70.f);
        make.centerX.equalTo(self);
    }];
    
    [self.pickedPieceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.kPickedPieceSize);
        make.height.equalTo(self.kPickedPieceSize);
        make.top.equalTo(self.boardView.mas_bottom).offset(15);
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

@end
