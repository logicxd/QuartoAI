//
//  QuartoAI.h
//  QuartoAI
//
//  Created by Aung Moe on 8/26/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuartoAI : NSObject

#pragma mark - Inits

- (instancetype)init; // Default is bot will start the game.
- (instancetype)initWithBotStartsTheGame:(BOOL)botStartsTheGame NS_DESIGNATED_INITIALIZER;

@end
