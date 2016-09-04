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

// Constants
@property (nonatomic, assign, readwrite) CGFloat kBigPieceSize;
@property (nonatomic, assign, readwrite) CGFloat kSmallPieceSize;
@property (nonatomic, assign, readwrite) CGFloat kOffSet;

// Views
@property (nonatomic, strong, readwrite) NSMutableArray<UIView *> *pieceSlots;
@property (nonatomic, strong, readwrite) NSMutableArray<QuartoPiece *> *pieces;
@end

@implementation QuartoPiecesView

#pragma mark - Visible Methods

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height {
    if (self = [super initWithFrame:CGRectMake(0, 0, width, height)]) {
        _pieces = [NSMutableArray arrayWithCapacity:kTotalPieces];
        _pieceSlots = [NSMutableArray arrayWithCapacity:kTotalPieces];
        [self loadInitialPiecesView];
        [self loadRandomizedPieces];
        [self addPiecestoView];
        
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

- (UIView *)getPieceSlotWithPieceIndex:(NSNumber *)pieceIndex {
    
    return nil;
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
    _kBigPieceSize = self.frame.size.width * (17.f/154.f);      //34.f
    _kOffSet = self.frame.size.width * (1.f/77.f);              //4.f
    
    // Position for each slot.
    CGFloat posX = self.kOffSet;
    CGFloat posY = self.kOffSet;
    
    
    // Set up pieceSlots
    for (NSInteger index = 0; index < kTotalPieces; index++) {
        // Make cell.
        [self.pieceSlots setObject:[[UIView alloc] initWithFrame:CGRectMake(posX, posY, self.kBigPieceSize, self.kBigPieceSize)]
                atIndexedSubscript:index];
        
        // Add background color to the cells
        self.pieceSlots[index].backgroundColor = [UIColor quartoGray];
        self.pieceSlots[index].layer.borderWidth = 2.0f;
        self.pieceSlots[index].layer.borderColor = [UIColor quartoBlack].CGColor;
        self.pieceSlots[index].layer.cornerRadius = self.frame.size.width / 6.f;
        
        // Add cell as a subview.
        [self addSubview:self.pieceSlots[index]];
        
        // Prepare for the next cell.
        if (index % 8 == 7) {
            posX = self.kOffSet;
            posY += self.kBigPieceSize + self.kOffSet;
        } else {
            posX += self.kBigPieceSize + self.kOffSet;
        }
    }
}

- (void)loadRandomizedPieces {
    
    for (NSUInteger index = 0; index < kTotalPieces; index++) {
        // Make a board piece
        self.pieces[index] = [[QuartoPiece alloc] initWithFrame:CGRectMake(0, 0, self.kBigPieceSize, self.kBigPieceSize)];
    }
    
    // Manually added the pictures I want.
    [self.pieces[0] setImage:[UIImage imageNamed:@"0-0-0.png"] pieceIndex:@(0)];
    [self.pieces[1] setImage:[UIImage imageNamed:@"0-0-0.png"] pieceIndex:@(1)];
    [self.pieces[2] setImage:[UIImage imageNamed:@"0-0-1.png"] pieceIndex:@(2)];
    [self.pieces[3] setImage:[UIImage imageNamed:@"0-0-1.png"] pieceIndex:@(3)];
    [self.pieces[4] setImage:[UIImage imageNamed:@"0-1-0.png"] pieceIndex:@(4)];
    [self.pieces[5] setImage:[UIImage imageNamed:@"0-1-0.png"] pieceIndex:@(5)];
    [self.pieces[6] setImage:[UIImage imageNamed:@"0-1-1.png"] pieceIndex:@(6)];
    [self.pieces[7] setImage:[UIImage imageNamed:@"0-1-1.png"] pieceIndex:@(7)];
    [self.pieces[8] setImage:[UIImage imageNamed:@"1-0-0.png"] pieceIndex:@(8)];
    [self.pieces[9] setImage:[UIImage imageNamed:@"1-0-0.png"] pieceIndex:@(9)];
    [self.pieces[10] setImage:[UIImage imageNamed:@"1-0-1.png"] pieceIndex:@(10)];
    [self.pieces[11] setImage:[UIImage imageNamed:@"1-0-1.png"] pieceIndex:@(11)];
    [self.pieces[12] setImage:[UIImage imageNamed:@"1-1-0.png"] pieceIndex:@(12)];
    [self.pieces[13] setImage:[UIImage imageNamed:@"1-1-0.png"] pieceIndex:@(13)];
    [self.pieces[14] setImage:[UIImage imageNamed:@"1-1-1.png"] pieceIndex:@(14)];
    [self.pieces[15] setImage:[UIImage imageNamed:@"1-1-1.png"] pieceIndex:@(15)];
    
    
    // Shuffle the pieces.
    NSUInteger count = [self.pieces count];
    for (NSUInteger index = 0; index < count - 1; index++) {
        NSInteger remainingCount = count - index;
        NSInteger exchangeIndex = index + arc4random_uniform((u_int32_t) remainingCount);
        [self.pieces exchangeObjectAtIndex:index withObjectAtIndex:exchangeIndex];
    }
}

- (void)addPiecestoView {
    for (NSUInteger index = 0; index < kTotalPieces; index++) {
        [self.pieceSlots[index] addSubview:self.pieces[index]];
    }
}

@end
