//
//  QuartoPiecesView.m
//  QuartoAI
//
//  Created by Aung Moe on 8/29/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoPiecesView.h"
#import "QuartoPiece.h"
#import "NSObject+QuartoColorTemplate.h"

static const NSInteger kTotalPieces = 16;

@interface QuartoPiecesView ()
@property (nonatomic, strong, readwrite) NSMutableArray<QuartoPiece *> *pieces;
@end

@implementation QuartoPiecesView

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _pieces = [NSMutableArray arrayWithCapacity:kTotalPieces];
        // Add manually all the pieces that will match with the bot.
        for (NSInteger index = 0; index < kTotalPieces; index++) {
            [self.pieces addObject:[[QuartoPiece alloc] initWithImage:[UIImage imageNamed:@"Airplane.png"]]];
        }
        
        // Settings for the QuartoPiecesView
        self.backgroundColor = [self quartoBlack];
        self.layer.borderColor = [self quartoBlack].CGColor;
        self.layer.borderWidth = 2.f;
        self.layer.cornerRadius = 10;
        self.layer.shadowOpacity = 1.f;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

- (void)removePieceWithIndex:(NSInteger)index {
    [self.pieces[index] setImage:nil];
}

#pragma mark - Set Frames

- (void)layoutSubviews {
    NSLog(@"Frame Width: %f Frame Height:%f", self.frame.size.width, self.frame.size.height);
    
    // Constants
    const CGFloat kViewWidth = self.frame.size.width;
    const CGFloat kCellSize = kViewWidth * (17.f/154.f);    //34.f
    const CGFloat kOffSet = kViewWidth * (1.f/77.f);        //4.f
    
    // Position for each slot.
    CGFloat posX = kOffSet;
    CGFloat posY = kOffSet;
    
    for (NSInteger index = 0; index < kTotalPieces; index++) {
        // Set cell size.
        [self.pieces[index] setFrame:CGRectMake(posX, posY, kCellSize, kCellSize)];
        
        // Add the cell to the view.
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
