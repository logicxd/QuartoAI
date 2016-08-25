//
//  QuartoView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoView.h"
#import "Masonry.h"

@interface QuartoView ()

@end

@implementation QuartoView

- (instancetype)init {
    if (self = [super init]) {
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Airplane.png"]];
        [self.imgView setUserInteractionEnabled:YES];
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imgView];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.center.equalTo(self);
    }];
    
    [super updateConstraints];
}


@end
