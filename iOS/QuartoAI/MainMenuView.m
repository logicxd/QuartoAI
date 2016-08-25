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
@property (nonatomic, strong) UIView *buttonContainer;
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
        [self.playerVsPlayerButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.playerVsPlayerButton setBackgroundColor:[UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1]];
        [self.playerVsPlayerButton addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        
        self.playerVsBotButton = [[UIButton alloc] init];
        self.playerVsBotButton.layer.cornerRadius = 10.f;
        [self.playerVsBotButton setTitle:@"Player vs Bot" forState:UIControlStateNormal];
        [self.playerVsBotButton setTitleColor:[UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1] forState:UIControlStateNormal];
        [self.playerVsBotButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.playerVsBotButton setBackgroundColor:[UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1]];
        [self.playerVsBotButton addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        
        self.howToButton = [[UIButton alloc] init];
        self.howToButton.layer.cornerRadius = 10.f;
        [self.howToButton setTitle:@"How to Play" forState:UIControlStateNormal];
        [self.howToButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.howToButton setTitleColor:[UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1] forState:UIControlStateNormal];
        [self.howToButton setBackgroundColor:[UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:1]];
        [self.howToButton addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        
        self.buttonContainer = [[UIView alloc] init];
        [self.buttonContainer addSubview:self.playerVsPlayerButton];
        [self.buttonContainer addSubview:self.playerVsBotButton];
        [self.buttonContainer addSubview:self.howToButton];
        
        self.creditLabel = [[UILabel alloc] init];
        self.creditLabel.font = [UIFont systemFontOfSize:10];
        self.creditLabel.text = @"Naahh Inc. All Rights Reserved";
        self.creditLabel.textAlignment = NSTextAlignmentCenter;
        self.creditLabel.textColor = [UIColor colorWithRed:82/255.f green:85/255.f blue:100/255.f alpha:1];
        self.creditLabel.backgroundColor =  [UIColor colorWithRed:254/255.f green:246/255.f blue:235/255.f alpha:.4];
        
        self.backgroundColor = [UIColor colorWithRed:194/255.f green:91/255.f blue:86/255.f alpha:1];
        [self addSubview:self.shimmeringTitle];
        [self addSubview:self.buttonContainer];
        [self addSubview:self.creditLabel];
    }
    return self;
}

- (void)buttonHit:(UIButton *)button {
    NSLog(@"\"%@\" is pressed", button.titleLabel.text);
    
    if (button == self.playerVsPlayerButton) {
        self.buttonHit(MainMenuButtonTypePlayerVsPlayer);
    } else if (button == self.playerVsBotButton) {
        self.buttonHit(MainMenuButtonTypePlayerVsBot);
    } else if (button == self.howToButton) {
        self.buttonHit(MainMenuButtonTypeHowTo);
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    NSNumber *buttonHeight = @45;
    CGFloat widthDimension = (self.bounds.size.width)*0.7;
    CGFloat heightDimension = (self.bounds.size.height)*0.4;
    CGFloat buttonHeightDimension = (heightDimension)/4;

    
    [self.shimmeringTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.buttonContainer.mas_top).offset(-25.f);
        make.centerX.equalTo(self);
        make.width.equalTo(self.buttonContainer);
        make.height.equalTo(buttonHeight);
    }];
    
    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(@(widthDimension));
        make.height.equalTo(@(heightDimension));
        
        [self.playerVsPlayerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.buttonContainer);
            make.height.equalTo(@(buttonHeightDimension));
        }];
        
        [self.playerVsBotButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerVsPlayerButton.mas_bottom).offset(10.f);
            make.left.right.equalTo(self.buttonContainer);
            make.height.equalTo(@(buttonHeightDimension));

        }];
        
        [self.howToButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerVsBotButton.mas_bottom).offset(10.f);
            make.left.right.equalTo(self.buttonContainer);
            make.height.equalTo(@(buttonHeightDimension));
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












