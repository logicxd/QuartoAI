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
@property (nonatomic, assign, readwrite) CGFloat kPieceSize;
@property (nonatomic, assign, readwrite) CGFloat kOffSet;
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
        self.layer.shadowRadius = 5;
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
    
    // Constants
    _kPieceSize = self.frame.size.width * (17.f/154.f);    //34.f
    _kOffSet = self.frame.size.width * (1.f/77.f);        //4.f
    
    // Position for each slot.
    CGFloat posX = self.kOffSet;
    CGFloat posY = self.kOffSet;
    
    for (NSInteger index = 0; index < kTotalPieces; index++) {
        // Make cell.
        [self.pieces setObject:[[QuartoPiece alloc] initWithFrame:CGRectMake(posX, posY, self.kPieceSize, self.kPieceSize)]
            atIndexedSubscript:index];
        
        // Add manually all the pieces that will match with the bot.
        [self.pieces[index] setImage:[UIImage imageNamed:@"Airplane.png"] pieceIndex:@(index)];
        
        // Add cell as a subview.
        [self addSubview:self.pieces[index]];
        
        // Prepare for the next cell.
        if (index % 8 == 7) {
            posX = self.kOffSet;
            posY += self.kPieceSize + self.kOffSet;
        } else {
            posX += self.kPieceSize + self.kOffSet;
        }
    }
    
    
}

@end
