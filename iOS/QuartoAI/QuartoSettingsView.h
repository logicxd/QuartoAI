//
//  QuartoSettingsView.h
//  QuartoAI
//
//  Created by Aung Moe on 9/7/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingsButton){
    SettingsButtonQuit,
    SettingsButtonRestart
};

@interface QuartoSettingsView : UIView
@property (nonatomic, copy) void (^buttonHit)(SettingsButton type);
@end
