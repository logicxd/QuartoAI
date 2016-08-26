//
//  QuartoBoardView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoBoardView.h"
#import "QuartoBoardViewCell.h"
#import "NSObject+QuartoColorTemplate.h"

static const NSInteger kTotalCells = 16;

@implementation QuartoBoardView

- (instancetype)init {
    if (self = [super init]) {
        self.board = [NSMutableArray arrayWithCapacity:kTotalCells];
        for (NSInteger index = 0; index < kTotalCells; index++) {
            [self.board addObject:[[QuartoBoardViewCell alloc] initWithFrame:CGRectZero]];
        }
        
        self.backgroundColor = [self quartoRed];
        self.layer.borderColor = [self quartoBlack].CGColor;
        self.layer.borderWidth = 2.f;
        self.layer.cornerRadius = 10;
        self.layer.shadowOpacity = 1.f;
        self.layer.shadowRadius = 10;
    }
    return self;
}

- (void)layoutSubviews {
    NSLog(@"Frame Width: %f Frame Height:%f", self.frame.size.width, self.frame.size.height);
    
    // Constants
    const CGFloat kBoardSize = self.frame.size.width;
    const CGFloat kCellSize = kBoardSize * (2.f/9.f);
    const CGFloat kOffSet = kBoardSize * (1.f/45.f);
    
    // Position for each slot.
    CGFloat posX = kOffSet;
    CGFloat posY = kOffSet; 
    
    for (NSInteger index = 0; index < kTotalCells; index++) {
        
//        if ([self.board objectAtIndex:index]) {
//        }
        
        // Create a cell.
        self.board[index] = [[QuartoBoardViewCell alloc] initWithFrame:CGRectMake(posX, posY, kCellSize, kCellSize)];
        
        // Add the cell to the view.
        [self addSubview:self.board[index]];
        
        // Prepare for the next cell.
        if (index % 4 == 3) {
            posX = kOffSet;
            posY += kCellSize + kOffSet;
        } else {
            posX += kCellSize + kOffSet;
        }
    }
}

@end
