//
//  MainMenuView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/24/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "MainMenuView.h"
#import "Masonry.h"
#import "FBShimmeringView.h"

@interface MainMenuView()
@property (nonatomic, strong) FBShimmeringView *shimmeringTitle;
@property (nonatomic, strong) UIView *buttonHolder;
@property (nonatomic, strong) UIButton *playerVsPlayerButton;
@property (nonatomic, strong) UIButton *playerVsBotButton;
@property (nonatomic, strong) UIButton *howToButton;
@property (nonatomic, strong) UILabel *creditLabel;
@end

@implementation MainMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *title = [[UILabel alloc] init];
        title.text = @"QuartoAI";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:40.f];
        title.textColor = [UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1];
       
        self.shimmeringTitle = [[FBShimmeringView alloc] initWithFrame:CGRectZero];
        self.shimmeringTitle.contentView = title;
        self.shimmeringTitle.shimmeringSpeed = 80;
        self.shimmeringTitle.shimmeringPauseDuration = 3;
        self.shimmeringTitle.shimmering = YES;
        
        self.playerVsPlayerButton = [[UIButton alloc] init];
        self.playerVsPlayerButton.layer.cornerRadius = 10.f;
        [self.playerVsPlayerButton setTitle:@"Player vs Player" forState:UIControlStateNormal];
        [self.playerVsPlayerButton setTitleColor:[UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1] forState:UIControlStateNormal];
        self.playerVsPlayerButton.backgroundColor = [UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1];
        
        self.playerVsBotButton = [[UIButton alloc] init];
        [self.playerVsBotButton setTitle:@"Player vs Bot" forState:UIControlStateNormal];
        self.playerVsBotButton.layer.cornerRadius = 10.f;
        [self.playerVsBotButton setTitleColor:[UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1] forState:UIControlStateNormal];
        self.playerVsBotButton.backgroundColor = [UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1];
        
        self.howToButton = [[UIButton alloc] init];
        [self.howToButton setTitle:@"How to Play" forState:UIControlStateNormal];
        self.howToButton.layer.cornerRadius = 10.f;
        [self.howToButton setTitleColor:[UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1] forState:UIControlStateNormal];
        self.howToButton.backgroundColor = [UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1];
        
        self.buttonHolder = [[UIView alloc] init];
        [self.buttonHolder addSubview:self.playerVsPlayerButton];
        [self.buttonHolder addSubview:self.playerVsBotButton];
        [self.buttonHolder addSubview:self.howToButton];
        
        self.creditLabel = [[UILabel alloc] init];
        self.creditLabel.font = [UIFont systemFontOfSize:10];
        self.creditLabel.text = @"LogicXD Entertainment Co.";
        self.creditLabel.textAlignment = NSTextAlignmentCenter;
        self.creditLabel.textColor = [UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1];
        self.creditLabel.backgroundColor =  [UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:.4];
        
        self.backgroundColor = [UIColor colorWithRed:194/255.f green:91/255.f blue:86/255.f alpha:1];
        [self addSubview:self.shimmeringTitle];
        [self addSubview:self.buttonHolder];
        [self addSubview:self.creditLabel];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    NSNumber *buttonHeight = @45;
    
    [self.shimmeringTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.buttonHolder.mas_top).offset(-25.f);
        make.centerX.equalTo(self);
        make.width.equalTo(self.buttonHolder);
        make.height.equalTo(buttonHeight);
    }];
    
    [self.buttonHolder mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@160);
        make.height.equalTo(@200);
        
        [self.playerVsPlayerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttonHolder);
            make.left.equalTo(self.buttonHolder);
            make.right.equalTo(self.buttonHolder);
            make.height.equalTo(buttonHeight);
        }];
        
        [self.playerVsBotButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerVsPlayerButton.mas_bottom).offset(10.f);
            make.left.equalTo(self.buttonHolder);
            make.right.equalTo(self.buttonHolder);
            make.height.equalTo(buttonHeight);
        }];
        
        [self.howToButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerVsBotButton.mas_bottom).offset(10.f);
            make.left.equalTo(self.buttonHolder);
            make.right.equalTo(self.buttonHolder);
            make.height.equalTo(buttonHeight);
        }];
    }];

    [self.creditLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@16);
    }];
    
    [super updateConstraints];
}

@end












