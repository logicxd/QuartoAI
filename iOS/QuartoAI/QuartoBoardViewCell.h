//
//  QuartoBoardViewCell.h
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartoBoardViewCell : UIView

@property (nonatomic, strong, readonly) NSNumber *pieceIndex;

- (instancetype)initWithFrame:(CGRect)frame;    // Initialize using this.
- (BOOL)putBoardPiece:(UIImageView *)boardPiece;// Returns YES if a board piece is put. NO if there's already a board piece.
- (BOOL)hasBoardPiece;                          // Returns YES if there's a board piece. NO otherwise.

@end
