//
//  QuartoAI.h
//  QuartoAI
//
//  Created by Aung Moe on 8/26/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuartoAI : NSObject

@property (nonatomic, copy, readonly) NSSet<NSNumber *> *kBoardPieces;    // All board pieces.
@property (nonatomic, strong, readonly) NSMutableDictionary *playingBoard;  // Holds current TTT board

#pragma mark - Bot Interactions

+ (NSArray<NSNumber *> *)winningIndiciesWithBoard:(NSDictionary *)board;
- (NSDictionary *)botMovedAtIndexWithBoard:(NSDictionary *)board pickedPiece:(NSNumber *)pickedPiece;

@end
