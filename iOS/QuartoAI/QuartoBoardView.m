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

@interface QuartoBoardView ()
@property (nonatomic, strong, readwrite) NSMutableArray<QuartoBoardViewCell *> *boardCells;
@end

@implementation QuartoBoardView

- (instancetype)init {
    if (self = [super init]) {
        
        _boardCells = [NSMutableArray arrayWithCapacity:kTotalCells];
        for (NSInteger index = 0; index < kTotalCells; index++) {
            [self.boardCells addObject:[[QuartoBoardViewCell alloc] initWithFrame:CGRectZero]];
        }
        
        self.backgroundColor = [self quartoBlack];
        self.layer.borderColor = [self quartoBlack].CGColor;
        self.layer.borderWidth = 2.f;
        self.layer.cornerRadius = 10;
        self.layer.shadowOpacity = 1.f;
        self.layer.shadowRadius = 10;
    }
    return self;
}

- (BOOL)canPutBoardPiece:(UIView *)boardPiece atIndex:(NSNumber *)index {
    return [self.boardCells[index.integerValue] canPutBoardPiece:boardPiece];
}

- (void)resetBoard {
    self.boardCells = [NSMutableArray arrayWithCapacity:kTotalCells];
    for (NSInteger index = 0; index < kTotalCells; index++) {
        [self.boardCells addObject:[[QuartoBoardViewCell alloc] initWithFrame:CGRectZero]];
    }
    
//    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"Frame Width: %f Frame Height:%f", self.frame.size.width, self.frame.size.height);
    
    // Constants
    const CGFloat kBoardSize = self.frame.size.width;
    const CGFloat kCellSize = kBoardSize * (1.f/5.f);
    const CGFloat kOffSet = kBoardSize * (1.f/25.f);
    
    // Position for each slot.
    CGFloat posX = kOffSet;
    CGFloat posY = kOffSet;
    
    for (NSInteger index = 0; index < kTotalCells; index++) {
        // Create a cell.
        [self.boardCells[index] setFrame:CGRectMake(posX, posY, kCellSize, kCellSize)];
        
        // Add the cell to the view.
        [self addSubview:self.boardCells[index]];
        
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
