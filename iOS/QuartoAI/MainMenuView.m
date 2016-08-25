//
//  MainMenuView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/24/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "MainMenuView.h"
#import "Masonry.h"

@interface MainMenuView()
@property (nonatomic, strong) UIView *buttonHolder;
@property (nonatomic, strong) UIButton *playerVsPlayerButton;
@property (nonatomic, strong) UIButton *playerVsBotButton;
@property (nonatomic, strong) UIButton *howToButton;
@end

@implementation MainMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.playerVsPlayerButton = [[UIButton alloc] init];
        self.playerVsPlayerButton.backgroundColor = [UIColor redColor];
        [self.playerVsPlayerButton setTitle:@"Player Vs Player" forState:UIControlStateNormal];
        self.playerVsPlayerButton.layer.cornerRadius = 10.f;
//        self.playerVsPlayerButton.layer.borderWidth = 1.5f;
//        self.playerVsPlayerButton.layer.borderColor = [UIColor orangeColor].CGColor;
        
        self.playerVsBotButton = [[UIButton alloc] init];
        self.playerVsBotButton.backgroundColor = [UIColor blueColor];
        [self.playerVsBotButton setTitle:@"Player Vs Bot" forState:UIControlStateNormal];
        self.playerVsBotButton.layer.cornerRadius = 10.f;
//        self.playerVsBotButton.layer.borderWidth = 1.5f;
//        self.playerVsBotButton.layer.borderColor = [UIColor orangeColor].CGColor;
        
        self.howToButton = [[UIButton alloc] init];
        self.howToButton.backgroundColor = [UIColor orangeColor];
        [self.howToButton setTitle:@"How To Play" forState:UIControlStateNormal];
        self.howToButton.layer.cornerRadius = 10.f;
//        self.howToButton.layer.borderWidth = 1.5f;
//        self.howToButton.layer.borderColor = [UIColor orangeColor].CGColor;
        
        self.buttonHolder = [[UIView alloc] init];
        [self.buttonHolder addSubview:self.playerVsPlayerButton];
        [self.buttonHolder addSubview:self.playerVsBotButton];
        [self.buttonHolder addSubview:self.howToButton];
        
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:self.buttonHolder];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    NSNumber *buttonHeight = @45;
    
    [self.buttonHolder mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@160);
        make.height.equalTo(@200);
    }];
    
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
    
    [super updateConstraints];
}

@end












