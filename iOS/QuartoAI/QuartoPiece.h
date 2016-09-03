//
//  QuartoPieces.h
//  QuartoAI
//
//  Created by Aung Moe on 8/29/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartoPiece : UIImageView

@property (nonatomic, strong, readonly) NSNumber *pieceIndex;

- (instancetype)initWithFrame:(CGRect)frame;                        // Initialize with this.
- (void)setImage:(UIImage *)image pieceIndex:(NSNumber *)pieceIndex;// Set image after initializing along with the piece index.

@end
