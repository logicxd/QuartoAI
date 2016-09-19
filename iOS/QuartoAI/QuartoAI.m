//
//  QuartoAI.m
//  QuartoAI
//
//  Created by Aung Moe on 8/26/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoAI.h"

static NSString *const kBoardKey = @"kBoardKey";
static NSString *const kDepthKey = @"kDepthKey";
static NSString *const kLastDepthKey = @"kLastDepthKey";
static NSString *const kLeafNode = @"kLeafNode";
static NSString *const kPlaceIndexKey = @"kPlaceIndexKey";
static NSString *const kPieceIndexKey = @"kPieceIndexKey";
static NSString *const kNextPossibleMovesKey = @"kNextPossibleMovesKey";
static NSString *const kNextPossiblePiecesKey = @"kNextPossiblePiecesKey";
static NSString *const kScoreKey = @"kScoreKey";
static const NSInteger kMaxNumOfMoves = 16;
static NSUInteger count = 0;

@interface QuartoAI ()
@property (nonatomic, copy, readwrite) NSSet<NSNumber *> *kBoardPieces; // Indicies 0 - 15
@end

@implementation QuartoAI

#pragma mark - Visible Methods

- (instancetype)init {
    if (self = [super init]) {
        
        // Create board pieces.
        NSMutableSet<NSNumber *> *temporaryBoardPieces = [NSMutableSet setWithCapacity:kMaxNumOfMoves];
        for (NSInteger index = 0; index < kMaxNumOfMoves; index++) {
            [temporaryBoardPieces addObject:@(index)];
        }
        _kBoardPieces = temporaryBoardPieces;
        
        // Create playingBoard.
        _playingBoard = [NSMutableDictionary dictionaryWithCapacity:kMaxNumOfMoves];
    }
    return self;
}

- (NSDictionary *)botMovedAtIndexWithBoard:(NSDictionary *)board pickedPiece:(NSNumber *)pickedPiece {
    NSDictionary *root = [self nextPossibleMovesWithBoard:board
                                                    alpha:NSIntegerMin
                                                     beta:NSIntegerMax
                                                    color:1
                                               depthLevel:@(board.count)
                                         searchDepthLevel:@(3)
                                              pickedPiece:pickedPiece];
    
    NSMutableString *listOfAllTheMoves = [NSMutableString stringWithCapacity:16];
    NSMutableString *listOfAllThePieces = [NSMutableString stringWithCapacity:16];
    
    // Get the best score for placing the piece.
    __block NSNumber *bestScoreForPlacingThePiece;
    [root enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [listOfAllTheMoves appendString:[NSString stringWithFormat:@"%@ ", (NSString *)key]];
        
        NSNumber *blockScore = obj[kScoreKey];
        if (!bestScoreForPlacingThePiece || blockScore.integerValue > bestScoreForPlacingThePiece.integerValue) {
            bestScoreForPlacingThePiece = blockScore;
        }
    }];
//    NSLog(@"%@", listOfAllTheMoves);
    
    // Pick a random move from the best scores of placing the piece.
    __block NSMutableArray *bestPlaces = [NSMutableArray arrayWithCapacity:16];
    [root enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSNumber *blockScore = obj[kScoreKey];
        if (blockScore.integerValue == bestScoreForPlacingThePiece.integerValue) {
            [bestPlaces addObject:key];
        }
    }];
    NSNumber *botPickPlace = bestPlaces[arc4random_uniform(bestPlaces.count)];
    
    // Get the best score from picking the pieces.
    NSDictionary *rootPieces = ((root[botPickPlace]) [kNextPossiblePiecesKey]);
    __block NSNumber *bestScoreForPickingAPiece;
    [rootPieces enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [listOfAllThePieces appendString:[NSString stringWithFormat:@"%@ ", (NSString *)key]];
        
        NSNumber *blockScore = obj[kScoreKey];
        if (!bestScoreForPickingAPiece || blockScore.integerValue > bestScoreForPickingAPiece.integerValue) {
            bestScoreForPickingAPiece = blockScore;
        }
    }];
//    NSLog(@"%@", listOfAllThePieces);

    
    // Pick a random piece from the best scores of the pieces.
    __block NSMutableArray *bestPieces = [NSMutableArray arrayWithCapacity:16];
    [rootPieces enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSNumber *blockScore = obj[kScoreKey];
        if (blockScore.integerValue == bestScoreForPickingAPiece.integerValue) {
            [bestPieces addObject:key];
        }
    }];
    NSNumber *botPickPiece = bestPieces[arc4random_uniform(bestPieces.count)];
    
//    NSInteger intKey = arc4random_uniform(botPicks.count);
//    NSNumber *botPickPlace = [botPicks[intKey] objectForKey:kPlaceIndexKey];
//    NSNumber *botPickPiece = [botPicks[intKey] objectForKey:kPieceIndexKey];
    NSLog(@"Count: %ld", (long)count);
//    NSLog(@"Bot places index: %ld   Picks piece index: %ld", (long)botPickPlace.integerValue, (long)botPickPiece.integerValue);
    count = 0;
//    return botPickPlace;
    return @{
             @"place" : botPickPlace,
             @"piece" : botPickPiece,
             };
}

#pragma mark - Negamax Alpha Beta Tree

- (NSDictionary *)nextPossibleMovesWithBoard:(NSDictionary *)board alpha:(NSInteger)alpha beta:(NSInteger)beta color:(NSInteger)color depthLevel:(NSNumber *)depthLevel searchDepthLevel:(NSNumber *)searchDepthLevel pickedPiece:(NSNumber *)pickedPiece{
    
    // If depthlevel is not the same as the stopping depth level. Depthlevel must be four or bigger AND there must have found a winner. OR depthlevel reached the end of the game.
    NSArray<NSNumber *> *winningIndicies;
    if ( (depthLevel.integerValue == depthLevel.integerValue + searchDepthLevel.integerValue) ||
         (depthLevel.integerValue >= 4 && (winningIndicies = [QuartoAI winningIndiciesWithBoard:board]) ) ||
         (depthLevel.integerValue == kMaxNumOfMoves) ) {
            
        NSMutableDictionary *leafNode = [NSMutableDictionary dictionary];
        leafNode[kBoardKey] = board;
        leafNode[kDepthKey] = depthLevel;
        leafNode[kLastDepthKey] = depthLevel;
        leafNode[kLeafNode] = kLeafNode;
        leafNode[kScoreKey] = winningIndicies ? @(-1 * color) : @(0);
        return leafNode;
    }
    
    /*
     We have "node" which represents how the board looks on the screen right now.
     We also have the "pickedPiece" which is for us to place on the board.
     1) Put the pickedPiece down.
     2) If the game hasn't ended, look for the best next piece to put.
     */
    
    NSMutableDictionary *node = [NSMutableDictionary dictionary];
    NSSet<NSNumber *> *availableMoves = [self availableMovesWithBoard:board];
    for (NSNumber *eachMove in availableMoves) {
        
        // Move dictionary.
        NSMutableDictionary *moveDictionary = [NSMutableDictionary dictionary];
        
        // Place Move
        NSDictionary *placedPickedPieceOnBoard = [self markBoard:board boardPiece:pickedPiece positionIndex:eachMove];
        moveDictionary[kBoardKey] = placedPickedPieceOnBoard;
        moveDictionary[kDepthKey] = depthLevel;
        moveDictionary[kPlaceIndexKey] = eachMove;
        
        // Pick next piece with the placedPickedPieceOnBoard.
        // If the board has a winner, then it won't choose any piece and terminates the game.
        NSMutableDictionary *piecesDictionary = [NSMutableDictionary dictionary];
        NSSet<NSNumber *> *availablePieces = [self availablePiecesWithBoard:placedPickedPieceOnBoard];
        for (NSNumber *eachPiece in availablePieces) {
            
            // Piece Dictionary.
            NSMutableDictionary *pieceDictionary = [NSMutableDictionary dictionary];
            
            // PickPiece dictionary.
            NSDictionary *nextNode = [self nextPossibleMovesWithBoard:placedPickedPieceOnBoard
                                                                           alpha:alpha
                                                                            beta:beta
                                                                           color:-color
                                                                      depthLevel:@(depthLevel.integerValue + 1)
                                                                searchDepthLevel:@(searchDepthLevel.integerValue - 1)
                                                                     pickedPiece:eachPiece];
            
            /*
             2 Possibilities.
             1) Game ends: score from placing the piece and reaching end game.
             2) Game continues: score for the next player in terms of the bot's perspective.
             */
            
            NSInteger score;
            // Case 1: Game ends
            if (nextNode[kLeafNode]) {
                score = [nextNode[kScoreKey] integerValue];
            }
            
            // Case 2: Game continues
            else {
                
                // Get the score with correct perspectives
                if (color == 1) {
                    
                    __block NSNumber *smallestScore;
                    [nextNode enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        NSNumber *blockScore = obj[kScoreKey];
                        if (!smallestScore || blockScore.integerValue < smallestScore.integerValue) {
                            smallestScore = blockScore;
                        }
                    }];
                    
                    // The opponent's going to do their worst.
                    score = smallestScore.integerValue;
                } else if (color == -1) {
                    
                    __block NSNumber *biggestScore;
                    [nextNode enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        NSNumber *blockScore = obj[kScoreKey];
                        if (!biggestScore || blockScore.integerValue > biggestScore.integerValue) {
                            biggestScore = blockScore;
                        }
                    }];
                    
                    // The bot's going to do the best.
                    score = biggestScore.integerValue;
                }
            }
            
            count++;
            pieceDictionary[kScoreKey] = @(score);  // The best score from the next player's perspective.
            pieceDictionary[kPieceIndexKey] = eachPiece;
            piecesDictionary[eachPiece] = pieceDictionary;
            if (color == 1) {
                
                // Bot's move
                if (score > alpha) {
                    alpha = score;
                }
                
                if (alpha >= beta) {
                    break;
                }
            } else if (color == -1) {
                
                // Player's move
                if (score < beta) {
                    beta = score;
                }
                
                if (alpha >= beta) {
                    break;
                }
            }
        }
        moveDictionary[kNextPossiblePiecesKey] = piecesDictionary;
        
        // Get the best score from kNextPossiblePiecesKey.
        if (color == 1) {
            
            __block NSNumber *bestScoreFromPieces;
            [piecesDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                NSNumber *eachPiecesScore = obj[kScoreKey];
                if (!bestScoreFromPieces || eachPiecesScore.integerValue > bestScoreFromPieces.integerValue) {
                    bestScoreFromPieces = eachPiecesScore;
                }
            }];
            
            moveDictionary[kScoreKey] = bestScoreFromPieces;
        } else if (color == -1) {
            
            __block NSNumber *worstScoreFromPieces;
            [piecesDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                NSNumber *eachPiecesScore = obj[kScoreKey];
                if (!worstScoreFromPieces || eachPiecesScore.integerValue < worstScoreFromPieces.integerValue) {
                    worstScoreFromPieces = eachPiecesScore;
                }
            }];
            
            moveDictionary[kScoreKey] = worstScoreFromPieces;
        }
        
        node[eachMove] = moveDictionary;
    }
    
    // Return all the moves that can be made, along with the scores.
    return node;
}

#pragma mark - Negamax Alpha Beta Score

// Return kScoreKey, kPieceKey, and kPlaceKey.
- (NSDictionary *)placePieceWithBoard:(NSDictionary *)board alpha:(NSInteger)alpha beta:(NSInteger)beta color:(NSInteger)color depthLevel:(NSNumber *)depthLevel searchDepthLevel:(NSNumber *)searchDepthLevel pickedPiece:(NSNumber *)pickedPiece{
    
    // Will place.
    NSSet<NSNumber *> *availableMoves = [self availableMovesWithBoard:board];
    NSMutableDictionary *placePiece = [NSMutableDictionary dictionary];
    
    if (availableMoves.count == 0) {
        NSLog(@"Error in %s", __PRETTY_FUNCTION__);
    }
    
    for (NSNumber *eachMove in availableMoves) {

        // Place at each spot.
        NSDictionary *newBoard = [self markBoard:board boardPiece:pickedPiece positionIndex:eachMove];
        
        // Pick a board piece.
        NSDictionary *pickPiece = [self pickPieceWithBoard:newBoard
                                                     alpha:alpha
                                                      beta:beta
                                                     color:color
                                                depthLevel:depthLevel
                                          searchDepthLevel:searchDepthLevel
                                               placedIndex:eachMove
                                   ];
        
        // Get score after placing the piece and picking a new piece.
        NSInteger score = [pickPiece[kScoreKey] integerValue];
        count++;
        if (color == 1) {
            // Bot's move
            if (score > alpha) {
                alpha = score;
                placePiece[kScoreKey] = @(score);
                placePiece[kPlaceIndexKey] = eachMove;
                placePiece[kPieceIndexKey] = pickPiece[kPieceIndexKey];
            }
        } else if (color == -1) {
            // Player's move
            if (score < beta) {
                beta = score;
                placePiece[kScoreKey] = @(score);
                placePiece[kPlaceIndexKey] = eachMove;
                placePiece[kPieceIndexKey] = pickPiece[kPieceIndexKey];
            }
            
        }
        
        // Cutoff
        if (alpha >= beta) {
            break;
        }
    }
    
    return placePiece;
}

// Returns kScoreKey, kPlaceKey, and kPieceKey if game is not complete. Returns only kScoreKey if the game is complete.
- (NSDictionary *)pickPieceWithBoard:(NSDictionary *)board alpha:(NSInteger)alpha beta:(NSInteger)beta color:(NSInteger)color depthLevel:(NSNumber *)depthLevel searchDepthLevel:(NSNumber *)searchDepthLevel placedIndex:(NSNumber *)placedIndex{
    
    NSArray<NSNumber *> *winningIndicies;
    NSSet<NSNumber *> *availablePieces = [self availablePiecesWithBoard:board];
    NSMutableDictionary *pickPiece = [NSMutableDictionary dictionary];

    if ( (depthLevel.integerValue == depthLevel.integerValue + searchDepthLevel.integerValue) ||
         (depthLevel.integerValue >= 4 && (winningIndicies = [QuartoAI winningIndiciesWithBoard:board]) ) ||
         (depthLevel.integerValue == kMaxNumOfMoves) ) {
            
            return @{
                     kScoreKey : winningIndicies ? @(1 * color) : @(0),
                     kPlaceIndexKey : placedIndex
                     };
    }
    
    if (!availablePieces) {
        NSLog(@"There are no more available pieces. Check terminating point.");
    }
    
    // Will pick a piece.
    for (NSNumber *eachPiece in availablePieces) {
        
        // Pick a piece.
        NSDictionary *placePiece = [self placePieceWithBoard:board
                                                       alpha:alpha
                                                        beta:beta
                                                       color:-color
                                                  depthLevel:@(depthLevel.integerValue + 1)
                                            searchDepthLevel:@(searchDepthLevel.integerValue - 1)
                                                 pickedPiece:eachPiece
                                    ];
        
        // Get score from picking the piece.
        NSInteger score = [placePiece[kScoreKey] integerValue];
        count++;
        if (color == 1) {
            // Bot's move
            if (score > alpha) {
                alpha = score;
                pickPiece[kScoreKey] = @(score);
                pickPiece[kPlaceIndexKey] = placePiece[kPlaceIndexKey];
                pickPiece[kPieceIndexKey] = eachPiece;
            }
        } else if (color == -1) {
            // Player's move
            if (score < beta) {
                beta = score;
                pickPiece[kScoreKey] = @(score);
                pickPiece[kPlaceIndexKey] = placePiece[kPlaceIndexKey];
                pickPiece[kPieceIndexKey] = eachPiece;
            }
        }
        
        // Cutoff
        if (alpha >= beta) {
            break;
        }
    }
    
    return pickPiece;
}

#pragma mark - Helper Methods

- (NSDictionary *)markBoard:(NSDictionary *)board boardPiece:(NSNumber *)boardPiece positionIndex:(NSNumber *)positionIndex {
    NSMutableDictionary *newBoard = [board mutableCopy];
    newBoard[positionIndex] = boardPiece;
    return newBoard;
}

- (NSSet<NSNumber *> *)availableMovesWithBoard:(NSDictionary *)board {
    NSMutableSet<NSNumber *> *availableMoves = [NSMutableSet setWithCapacity:kMaxNumOfMoves];
    for (NSInteger index = 0; index < kMaxNumOfMoves; index++) {
        if (!board[@(index)]) {
            [availableMoves addObject:@(index)];
        }
    }
    return availableMoves;
}

// Some of the characters are wonky. They become pointers???? Seems to work though.
- (NSSet<NSNumber *> *)availablePiecesWithBoard:(NSDictionary *)board {
    NSMutableSet<NSNumber *> *availablePieces = [self.kBoardPieces mutableCopy];
    for (NSNumber *eachPiece in [board allValues]) {
        [availablePieces removeObject:eachPiece];
    }
    return availablePieces;
}

+ (NSArray<NSNumber *> *)winningIndiciesWithBoard:(NSDictionary *)board {
    if (board.count < 4) {
        return nil;
    }
    
    if (board[@3] && board[@6] && board[@9] && board[@12]) {
        /**
         
         - - - *
         - - * -
         - * - -
         * - - -
         
         */
        
        NSArray<NSNumber *> *rowArray = @[board[@3], board[@6], board[@9], board[@12]];
        if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
            return @[@3, @6, @9, @12];
        }
    }
    
    if (board[@0] && board[@5] && board[@10] && board[@15]) {
        /**
         
         * - - -
         - * - -
         - - * -
         - - - *
         
         */
        
        
        NSArray<NSNumber *> *rowArray = @[board[@0], board[@5], board[@10], board[@15]];
        if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
            return @[@0, @5, @10, @15];
        }
    }
    
    if (board[@0]) {
        /**
         
         * * * *
         * - - -
         * - - -
         * - - -
         
         */
        if (board[@3] && board[@2] && board[@1]) {
            NSArray<NSNumber *> *rowArray = @[board[@0], board[@3], board[@2], board[@1]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@0, @1, @2, @3];
            }
        }
        
        if (board[@12] && board[@8] && board[@4]) {
            NSArray<NSNumber *> *rowArray = @[board[@0], board[@12], board[@8], board[@4]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@0, @4, @8, @12];
            }
        }
    }
    
    if (board[@5]) {
        /**
         
         - * - -
         * * * *
         - * - -
         - * - -
         
         */
        if (board[@13] && board[@9] && board[@1]) {
            NSArray<NSNumber *> *rowArray = @[board[@5], board[@13], board[@9], board[@1]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@1, @5, @9, @13];
            }
        }
        
        if (board[@4] && board[@6] && board[@7]) {
            NSArray<NSNumber *> *rowArray = @[board[@5], board[@4], board[@6], board[@7]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@4, @5, @6, @7];
            }
        }
    }
    
    if (board[@10]) {
        /**
         
         - - * -
         - - * -
         * * * *
         - - * -
         
         */
        if (board[@8] && board[@9] && board[@11]) {
            NSArray<NSNumber *> *rowArray = @[board[@10], board[@8], board[@9], board[@11]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@8, @9, @10, @11];
            }
        }
        
        if (board[@2] && board[@6] && board[@14]) {
            NSArray<NSNumber *> *rowArray = @[board[@10], board[@2], board[@6], board[@14]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@2, @6, @10, @14];
            }
        }
    }
    
    if (board[@15]) {
        /**
         
         - - - *
         - - - *
         - - - *
         * * * *
         
         */
        if (board[@12] && board[@13] && board[@14]) {
            NSArray<NSNumber *> *rowArray = @[board[@15], board[@12], board[@13], board[@14]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@12, @13, @14, @15];
            }
        }
        
        if (board[@3] && board[@7] && board[@11]) {
            NSArray<NSNumber *> *rowArray = @[board[@15], board[@3], board[@7], board[@11]];
            if ([QuartoAI hasSameAttributeWithRow:rowArray]) {
                return @[@3, @7, @11, @15];
            }
        }
    }
    
    return nil;
}

+ (BOOL)hasSameAttributeWithRow:(NSArray<NSNumber *> *)row {
    if (row.count != 4) {
        return NO;
    }
    
    NSMutableArray<NSNumber *> *attributesInRow = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger index = 0; index < row.count; index++) {
        NSInteger num = row[index].integerValue;
        
        if (num == 0) {
            [attributesInRow addObject:@(0)];   //0000
        } else if (num == 1) {
            [attributesInRow addObject:@(1)];   //0001
        } else if (num == 2) {
            [attributesInRow addObject:@(10)];  //0010
        } else if (num == 3) {
            [attributesInRow addObject:@(11)];  //0011
        } else if (num == 4) {
            [attributesInRow addObject:@(100)]; //0100
        } else if (num == 5) {
            [attributesInRow addObject:@(101)]; //0101
        } else if (num == 6) {
            [attributesInRow addObject:@(110)]; //0110
        } else if (num == 7) {
            [attributesInRow addObject:@(111)]; //0111
        } else if (num == 8) {
            [attributesInRow addObject:@(1000)];
        } else if (num == 9) {
            [attributesInRow addObject:@(1001)];
        } else if (num == 10) {
            [attributesInRow addObject:@(1010)];
        } else if (num == 11) {
            [attributesInRow addObject:@(1011)];
        } else if (num == 12) {
            [attributesInRow addObject:@(1100)];
        } else if (num == 13) {
            [attributesInRow addObject:@(1101)];
        } else if (num == 14) {
            [attributesInRow addObject:@(1110)];
        } else if (num == 15) {
            [attributesInRow addObject:@(1111)];
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
