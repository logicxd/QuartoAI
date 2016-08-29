//
//  QuartoAI.m
//  QuartoAI
//
//  Created by Aung Moe on 8/26/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoAI.h"

static NSString *const kNextPossibleBoardsKey = @"kNextPossibleBoardsKey";
static NSString *const kScoreKey = @"kScoreKey";
static NSString *const kBoardKey = @"kBoardKey";
static NSString *const kDepthKey = @"kDepthKey";
static NSString *const kPositionIndexKey = @"kPositionIndexKey";
static const NSInteger kMaxNumOfMoves = 16;
//static NSInteger count = 0;

@interface QuartoAI ()
@property (nonatomic, strong, readwrite) NSSet<NSNumber *> *kBoardPieces; // Indicies
@property (nonatomic, strong, readwrite) NSMutableDictionary *playingBoard;
@end

@implementation QuartoAI

#pragma mark - Visible Methods

- (instancetype)init {
    if (self = [super init]) {
        
        // Create pieces.
        NSMutableSet<NSNumber *> *temporaryBoardPieces = [NSMutableSet setWithCapacity:kMaxNumOfMoves];
        for (NSInteger index = 0; index < kMaxNumOfMoves; index++) {
            [temporaryBoardPieces addObject:@(index)];
        }
        _kBoardPieces = temporaryBoardPieces;
        
    }
    return self;
}

#pragma mark - Private Methods Below This Line


#pragma mark - Negamax Alpha Beta Scoring

- (NSDictionary *)negaMaxAlphaBetaWithBoard:(NSDictionary *)board depthLevel:(NSNumber *)depthLevel color:(NSInteger)color {
    // Someone just made a move.
    NSArray<NSNumber *> *winningIndicies;
    if ((depthLevel.integerValue >= 4 && (winningIndicies = [self winningIndiciesWithBoard:board])) || depthLevel.integerValue == kMaxNumOfMoves) {
        NSMutableDictionary *leafNode = [NSMutableDictionary dictionary];
        leafNode[kBoardKey] = board;
        leafNode[kDepthKey] = depthLevel;
        leafNode[kNextPossibleBoardsKey] = nil;
        leafNode[kScoreKey] = winningIndicies ? @(1 * color) : @(0);
    }
    
    return nil;
}

#pragma mark - Helper Methods

- (NSSet *)availableMovesWithBoard:(NSDictionary *)board {
    NSMutableSet *availableMoves = [NSMutableSet setWithCapacity:kMaxNumOfMoves];
    for (NSInteger index = 0; index < kMaxNumOfMoves; index++) {
        if (!board[@(index)]) {
            [availableMoves addObject:@(index)];
        }
    }
    return availableMoves;
}

- (NSSet *)availablePiecesWithBoard:(NSDictionary *)board {
    NSMutableSet *availablePieces = [self.kBoardPieces mutableCopy];
    for (NSNumber *eachPiece in [board allValues]) {
        [availablePieces removeObject:eachPiece];
    }
    return availablePieces;
}

- (NSArray<NSNumber *> *)winningIndiciesWithBoard:(NSDictionary *)board {
    if (board[@0]) {
        /**
         
         * * * *
         * - - -
         * - - -
         * - - -
         
         */
        if (board[@3] && board[@2] && board[@1]) {
            NSArray<NSNumber *> *rowArray = @[board[@0], board[@3], board[@2], board[@1]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
        
        if (board[@12] && board[@8] && board[@4]) {
            NSArray<NSNumber *> *rowArray = @[board[@0], board[@12], board[@8], board[@4]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
    } else if (board[@5]) {
        /**
         
         - * - -
         * * * *
         - * - -
         - * - -
         
         */
        if (board[@13] && board[@9] && board[@1]) {
            NSArray<NSNumber *> *rowArray = @[board[@5], board[@13], board[@9], board[@1]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
        
        if (board[@4] && board[@6] && board[@7]) {
            NSArray<NSNumber *> *rowArray = @[board[@5], board[@4], board[@6], board[@7]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
    } else if (board[@10]) {
        /**
         
         - - * -
         - - * -
         * * * *
         - - * -
         
         */
        if (board[@8] && board[@9] && board[@11]) {
            NSArray<NSNumber *> *rowArray = @[board[@10], board[@8], board[@9], board[@11]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
        
        if (board[@2] && board[@6] && board[@14]) {
            NSArray<NSNumber *> *rowArray = @[board[@10], board[@2], board[@6], board[@14]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
    } else if (board[@15]) {
        /**
         
         - - - *
         - - - *
         - - - *
         * * * *
         
         */
        if (board[@12] && board[@13] && board[@14]) {
            NSArray<NSNumber *> *rowArray = @[board[@15], board[@12], board[@13], board[@14]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
        
        if (board[@3] && board[@7] && board[@15]) {
            NSArray<NSNumber *> *rowArray = @[board[@15], board[@3], board[@7], board[@15]];
            if ([self hasSameAttributeWithRow:rowArray]) {
                return rowArray;
            }
        }
    }
    
    return nil;
}

- (BOOL)hasSameAttributeWithRow:(NSArray<NSNumber *> *)row {
    if (row.count != 4) {
        return NO;
    }
    
    NSMutableArray<NSNumber *> *attributesInRow = [NSMutableArray arrayWithCapacity:4];
    for (NSNumber *eachPiece in row) {
        NSInteger num = eachPiece.integerValue;
    
        if (num == 0) {
            [attributesInRow addObject:@0000];
        } else if (num == 1) {
            [attributesInRow addObject:@0001];
        } else if (num == 2) {
            [attributesInRow addObject:@0010];
        } else if (num == 3) {
            [attributesInRow addObject:@0011];
        } else if (num == 4) {
            [attributesInRow addObject:@0100];
        } else if (num == 5) {
            [attributesInRow addObject:@0101];
        } else if (num == 6) {
            [attributesInRow addObject:@0110];
        } else if (num == 7) {
            [attributesInRow addObject:@0111];
        } else if (num == 8) {
            [attributesInRow addObject:@1000];
        } else if (num == 9) {
            [attributesInRow addObject:@1001];
        } else if (num == 10) {
            [attributesInRow addObject:@1010];
        } else if (num == 11) {
            [attributesInRow addObject:@1011];
        } else if (num == 12) {
            [attributesInRow addObject:@1100];
        } else if (num == 13) {
            [attributesInRow addObject:@1101];
        } else if (num == 14) {
            [attributesInRow addObject:@1110];
        } else if (num == 15) {
            [attributesInRow addObject:@1111];
        }
    }
    
    BOOL hasAttribute = NO;
    for (NSInteger index = 0; index < 4; index++) {
        // Gets the last digit.
        NSInteger a = attributesInRow[0].integerValue % 10;
        NSInteger b = attributesInRow[1].integerValue % 10;
        NSInteger c = attributesInRow[2].integerValue % 10;
        NSInteger d = attributesInRow[3].integerValue % 10;
        
        if (a == b && b == c  && c == d) {
            hasAttribute = YES;
            break;
        } else {
            // Removes the last digit.
            attributesInRow[0] = @(attributesInRow[0].integerValue / 10);
            attributesInRow[1] = @(attributesInRow[1].integerValue / 10);
            attributesInRow[2] = @(attributesInRow[2].integerValue / 10);
            attributesInRow[3] = @(attributesInRow[3].integerValue / 10);
        }
    }
    
    return hasAttribute;
}

@end
