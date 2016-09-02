//
//  QuartoPiecesView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/29/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoPiecesView.h"
#import "QuartoPiece.h"
#import "UIColor+QuartoColor.h"

static const NSInteger kTotalPieces = 16;

@interface QuartoPiecesView ()
@property (nonatomic, strong, readwrite) NSMutableArray<QuartoPiece *> *pieces;
@end

@implementation QuartoPiecesView

#pragma mark - Visible Methods

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height {
    if (self = [super initWithFrame:CGRectMake(0, 0, width, height)]) {
        _pieces = [NSMutableArray arrayWithCapacity:kTotalPieces];
        [self loadInitialPiecesView];
        
        self.backgroundColor = [UIColor quartoBlack];
        self.layer.borderColor = [UIColor quartoBlack].CGColor;
        self.layer.borderWidth = 2.f;
        self.layer.cornerRadius = 10;
        self.layer.shadowOpacity = 1.f;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

- (void)resetBoard {
    [self loadInitialPiecesView];
}

#pragma mark - Private Methods

- (void)loadInitialPiecesView {
    // Precondition: self.pieces must be initialized.
    
    // Remove all the subviews first.
    for (UIView *eachView in self.subviews) {
        [eachView removeFromSuperview];
    }
    
//    NSLog(@"Frame Width: %f Frame Height:%f", self.frame.size.width, self.frame.size.height);
    
    // Constants
    const CGFloat kViewWidth = self.frame.size.width;
    const CGFloat kCellSize = kViewWidth * (17.f/154.f);    //34.f
    const CGFloat kOffSet = kViewWidth * (1.f/77.f);        //4.f
    
    // Position for each slot.
    CGFloat posX = kOffSet;
    CGFloat posY = kOffSet;
    
    for (NSInteger index = 0; index < kTotalPieces; index++) {
        // Make cell.
        [self.pieces setObject:[[QuartoPiece alloc] initWithFrame:CGRectMake(posX, posY, kCellSize, kCellSize)]
            atIndexedSubscript:index];
        
        // Add manually all the pieces that will match with the bot.
        [self.pieces[index] setImage:[UIImage imageNamed:@"Airplane.png"]];
        
        // Add cell as a subview.
        [self addSubview:self.pieces[index]];
        
        // Prepare for the next cell.
        if (index % 8 == 7) {
            posX = kOffSet;
            posY += kCellSize + kOffSet;
        } else {
            posX += kCellSize + kOffSet;
        }
    }
}

@end
