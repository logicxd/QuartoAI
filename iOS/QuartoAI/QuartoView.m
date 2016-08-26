//
//  QuartoView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoView.h"
#import "QuartoBoardView.h"
#import "Masonry.h"
#import "NSObject+QuartoColorTemplate.h"

@interface QuartoView ()
@property (nonatomic, strong) QuartoBoardView *board;
@end

@implementation QuartoView

- (instancetype)init {
    if (self = [super init]) {
        
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Airplane.png"]];
        [self.imgView setUserInteractionEnabled:YES];
        
        self.board = [[QuartoBoardView alloc] init];
        
        self.backgroundColor = [self quartoWhite];
        [self addSubview:self.board];
        [self addSubview:self.imgView];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    [self.board mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@200);
        make.center.equalTo(self);
    }];
    
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.top.equalTo(self.board);
        make.left.equalTo(self);
    }];
    
    [super updateConstraints];
}


@end
