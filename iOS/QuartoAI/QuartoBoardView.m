//
//  QuartoBoardView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoBoardView.h"
#import "QuartoBoardViewCell.h"
#import "UIColor+QuartoColor.h"


static const NSInteger kTotalCells = 16;

@interface QuartoBoardView ()
@property (nonatomic, strong, readwrite) NSMutableArray<QuartoBoardViewCell *> *boardCells;
@end

@implementation QuartoBoardView


#pragma mark - Visible Methods

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height {
    if (self = [super initWithFrame:CGRectMake(0, 0, width, height)]) {
        _boardCells = [NSMutableArray arrayWithCapacity:kTotalCells];
        [self loadInitialBoardView];
        
        self.backgroundColor = [UIColor quartoBlack];
        self.layer.borderColor = [UIColor quartoBlack].CGColor;
        self.layer.borderWidth = 2.f;
        self.layer.cornerRadius = 10;
        self.layer.shadowOpacity = 1.f;
        self.layer.shadowRadius = 10;
    }
    return self;
}

- (BOOL)canPutBoardPiece:(UIImageView *)boardPiece atIndex:(NSNumber *)index {
    return [self.boardCells[index.integerValue] canPutBoardPiece:boardPiece];
}

- (void)resetBoard {
    [self loadInitialBoardView];
}

#pragma mark - Private Methods

- (void)loadInitialBoardView {
    // Precondition: self.boardCells must be initialized.
    
    // Remove all the subviews first.
    for (UIView *eachView in self.subviews) {
        [eachView removeFromSuperview];
    }
    
    NSLog(@"Frame Width: %f Frame Height:%f", self.frame.size.width, self.frame.size.height);
    
    // Constants
    const CGFloat kBoardSize = self.frame.size.width;
    const CGFloat kCellSize = kBoardSize * (1.f/5.f);   // 45.f
    const CGFloat kOffSet = kBoardSize * (1.f/25.f);    // 9.f
    
    // Position for each slot.
    CGFloat posX = kOffSet;
    CGFloat posY = kOffSet;
    
    for (NSInteger index = 0; index < kTotalCells; index++) {
        // Make cell.
        [self.boardCells setObject:[[QuartoBoardViewCell alloc] initWithFrame:CGRectMake(posX, posY, kCellSize, kCellSize)]
                atIndexedSubscript:index];
        
        // Add cell as a subview.
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
