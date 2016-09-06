//
//  MainMenuView.h
//  QuartoAI
//
//  Created by Aung Moe on 8/24/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MainMenuButtonType){
    MainMenuButtonTypePlayerVsPlayer,
    MainMenuButtonTypePlayerVsBot,
    MainMenuButtonTypeHowTo
};

@interface MainMenuView : UIView
@property (nonatomic, copy) void (^buttonHit)(MainMenuButtonType button);
- (instancetype)init;
@end
