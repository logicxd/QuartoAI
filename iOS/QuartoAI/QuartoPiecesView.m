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
@property (nonatomic, assign, readwrite) CGFloat kSlotSize;
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
        [self resetBoard];
     
        self.backgroundColor = [UIColor quartoGray];
        self.layer.cornerRadius = 5.f;
        self.layer.shadowOpacity = .5f;
        self.layer.shadowRadius = 1;
        self.layer.shadowOffset = CGSizeMake(0, 6);
    }
    return self;
}

- (UIView *)getTheSlotThatThePieceIsInWithIndex:(NSNumber *)index {
    for (UIView *eachView in self.pieceSlots) {
        QuartoPiece *piece = [[eachView subviews] firstObject];
        if ([piece.pieceIndex isEqualToNumber:index]) {
            return eachView;
        }
    }
    return nil;
}

- (NSNumber *)getSlotPositionOfPieceIndex:(NSNumber *)index {
    for (NSInteger i = 0; i < self.pieceSlots.count; i++) {
        UIView *eachView = self.pieceSlots[i];
        QuartoPiece *piece = [[eachView subviews] firstObject];
        
        if ([piece.pieceIndex isEqualToNumber:index]) {
            return @(i);
        }
    }
    return nil;
}

- (QuartoPiece *)removePieceAtSlot:(NSInteger)index {
    UIView *pieceView = [[self.pieceSlots[index] subviews] firstObject];
    if (!pieceView) {
        return nil;
    }
    
    [pieceView removeFromSuperview];
    pieceView.userInteractionEnabled = YES;
    return (QuartoPiece *)pieceView;
}

- (void)resetBoard {
    _pieces = [NSMutableArray arrayWithCapacity:kTotalPieces];
    _pieceSlots = [NSMutableArray arrayWithCapacity:kTotalPieces];
    [self loadInitialPiecesView];
    [self loadRandomizedPieces];
    [self addPiecestoView];
}

#pragma mark - Private Methods

- (void)loadInitialPiecesView {
    // Remove all the subviews first.
    for (UIView *eachView in self.subviews) {
        [eachView removeFromSuperview];
    }
    
    // Constants
    _kSlotSize = self.frame.size.width * (17.f/154.f);          // 34.f
    _kOffSet = self.frame.size.width * (1.f/77.f);              // 4.f
    
    // Position for each slot.
    CGFloat posX = self.kOffSet;
    CGFloat posY = self.kOffSet;
    
    
    // Set up pieceSlots
    for (NSInteger index = 0; index < kTotalPieces; index++) {
        // Make cell.
        [self.pieceSlots setObject:[[UIView alloc] initWithFrame:CGRectMake(posX, posY, self.kSlotSize, self.kSlotSize)]
                atIndexedSubscript:index];
        
        // Add background color to the cells
//        self.pieceSlots[index].backgroundColor = [UIColor clearColor];
//        self.pieceSlots[index].layer.borderWidth = 2.0f;
//        self.pieceSlots[index].layer.borderColor = [UIColor quartoBlack].CGColor;
//        self.pieceSlots[index].layer.cornerRadius = 10.f;
        
        // Add cell as a subview.
        [self addSubview:self.pieceSlots[index]];
        
        // Prepare for the next cell.
        if (index % 8 == 7) {
            posX = self.kOffSet;
            posY += self.kSlotSize + self.kOffSet;
        } else {
            posX += self.kSlotSize + self.kOffSet;
        }
    }
}

- (void)loadRandomizedPieces {
    // Constants
    _kBigPieceSize = 30.f;
    _kSmallPieceSize = 18.f;
    
    // Make a board piece.
    for (NSUInteger index = 0; index < kTotalPieces; index++) {
        // Even indices are big piece.
        if (index % 2 == 0) {
            self.pieces[index] = [[QuartoPiece alloc] initWithFrame:CGRectMake(0, 0, self.kBigPieceSize, self.kBigPieceSize)];
        } else {
            // Odd indices are small piece.
            self.pieces[index] = [[QuartoPiece alloc] initWithFrame:CGRectMake(0, 0, self.kSmallPieceSize, self.kSmallPieceSize)];
        }
        
        // Center the pieces.
        self.pieces[index].center = CGPointMake(self.kSlotSize/2.f, self.kSlotSize/2.f);
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
