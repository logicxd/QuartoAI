//
//  QuartoSettingsView.m
//  QuartoAI
//
//  Created by Aung Moe on 9/7/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoSettingsView.h"
#import "Masonry.h"
#import "UIColor+QuartoColor.h"

const CGFloat kViewWidth = 250.f;
const CGFloat kViewHeight = 300.f;

@interface QuartoSettingsView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *quitButton;
@end

@implementation QuartoSettingsView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)]) {
        
        // Constants.
        const CGFloat kEdgeOffset = 10.f;
        const CGFloat kTitleWidth = 150.f;
        const CGFloat kTitleHeight = 45.f;
        const CGFloat kButtonWidth = 110.f;
        const CGFloat kButtonHeight = 45.f;
        
        
        // Title label.
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewWidth/2 - kTitleWidth/2,
                                                                kEdgeOffset,
                                                                kTitleWidth,
                                                                kTitleHeight)];
        self.titleLabel.text = @"QuartoAI";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:30.f];
        self.titleLabel.textColor = [UIColor quartoWhite];
        [self addSubview:self.titleLabel];
        
        // Restart Button
        _restartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.restartButton.frame = CGRectMake(kEdgeOffset,                                  // 10
                                              kViewHeight-kEdgeOffset-kButtonHeight-6,      // 239
                                              kButtonWidth,                                 // 110
                                              kButtonHeight);                               // 45
        self.restartButton.layer.cornerRadius = 5.f;
        self.restartButton.layer.shadowOpacity = .5f;
        self.restartButton.layer.shadowRadius = 1;
        self.restartButton.layer.shadowOffset = CGSizeMake(0, 6);
        [self.restartButton setTitle:@"Restart" forState:UIControlStateNormal];
        [self.restartButton setTitleColor:[UIColor quartoBlack] forState:UIControlStateNormal];
        [self.restartButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.restartButton setBackgroundColor:[UIColor quartoWhite]];
        [self.restartButton addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.restartButton];
        
        // Quit Button
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.quitButton.frame = CGRectMake(kEdgeOffset*2+kButtonWidth,                      // 130
                                           kViewHeight-kEdgeOffset-kButtonHeight-6,         // 239
                                           kButtonWidth,                                    // 110
                                           kButtonHeight);                                  // 45
        self.quitButton.layer.cornerRadius = 5.f;
        self.quitButton.layer.shadowOpacity = .5f;
        self.quitButton.layer.shadowRadius = 1;
        self.quitButton.layer.shadowOffset = CGSizeMake(0, 6);
        [self.quitButton setTitle:@"Quit" forState:UIControlStateNormal];
        [self.quitButton setTitleColor:[UIColor quartoBlack] forState:UIControlStateNormal];
        [self.quitButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.quitButton setBackgroundColor:[UIColor quartoWhite]];
        [self.quitButton addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.quitButton];
        
        // Settings
        self.backgroundColor = [UIColor quartoRed];
        self.layer.cornerRadius = 10.f;
    }
    return self;
}

- (void)buttonHit:(UIButton *)button {
    
    if (button == self.restartButton) {
        NSLog(@"\"Restart\" is pressed");
        self.buttonHit(SettingsButtonRestart);
    } else if (button == self.quitButton) {
        NSLog(@"\"Quit\" is pressed");
        self.buttonHit(SettingsButtonQuit);
    }
}

@end
