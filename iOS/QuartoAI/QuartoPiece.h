//
//  QuartoPieces.h
//  QuartoAI
//
//  Created by Aung Moe on 8/29/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartoPiece : UIImageView


- (instancetype)initWithFrame:(CGRect)frame;    // Initialize with this.
- (void)setImage:(UIImage *)image;              // Set image after initializing. (Easier than initializing with image)

@end
