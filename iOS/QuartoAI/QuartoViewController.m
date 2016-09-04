//
//  GameViewController.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoViewController.h"
#import "QuartoView.h"
#import "QuartoBoardView.h"
#import "QuartoBoardViewCell.h"
#import "QuartoPiecesView.h"
#import "QuartoPiece.h"
#import "QuartoAI.h"
#import "UIColor+QuartoColor.h"

@interface QuartoViewController ()

// Class variables for drag and drop.
@property (nonatomic, assign) CGPoint firstTouchPoint;      // Saves the location of the first touch.
@property (nonatomic, assign) NSNumber *pieceIndex;         // The index of the touched piece.
@property (nonatomic, assign) float xDistanceTouchPoint;    // X distance between img center and firstTouchPointer.center.
@property (nonatomic, assign) float yDistanceTouchPoint;    // Y distance between img center and firstTouchPointer.center.

// Handling Views
@property (nonatomic, strong) QuartoView *quartoView;
@property (nonatomic, assign) BOOL showGameGuides;
@property (nonatomic, assign) NSInteger shownGameGuidesCount;

// Bot Interactions
@property (nonatomic, assign) BOOL isPlayerVsPlayer;
@property (nonatomic, strong) QuartoAI *bot;

@end

@implementation QuartoViewController

- (instancetype)initWithIsPlayerVsPlayer:(BOOL)isPlayerVsPlayer {
    if (self = [super init]) {
        _isPlayerVsPlayer = isPlayerVsPlayer;
    }
    return self;
}

- (void)loadView {
    _quartoView = [[QuartoView alloc] init];
    _showGameGuides = YES;
    _shownGameGuidesCount = 0;
    
    self.quartoView.piecesView.layer.shadowColor = [UIColor quartoBlue].CGColor;
    self.quartoView.nameLabel1.layer.borderColor = [UIColor quartoBlue].CGColor;
    self.view = self.quartoView;
}

- (void)viewDidLoad {
    _bot = [[QuartoAI alloc] init];
    
    
}

- (void)resetGame {
    [self.quartoView.boardView resetBoard];
    [self.quartoView.piecesView resetBoard];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[QuartoPiece class]]) {
        // The location of where the object was touched.
        self.firstTouchPoint = [touch locationInView:self.view];
        self.pieceIndex = [((QuartoPiece *) touch.view) pieceIndex];
        self.xDistanceTouchPoint = self.firstTouchPoint.x - touch.view.center.x;
        self.yDistanceTouchPoint = self.firstTouchPoint.y - touch.view.center.y;
        
        // Make the object on top of other views.
        touch.view.layer.zPosition = 1;
        
        if (self.showGameGuides && [self.quartoView hasAPieceInPickedPieceView]) {
            self.quartoView.pickedPieceView.layer.shadowColor = [UIColor blackColor].CGColor;
            self.quartoView.boardView.layer.shadowColor = [UIColor quartoBlue].CGColor;
        } else if (self.showGameGuides) {
            self.quartoView.piecesView.layer.shadowColor = [UIColor blackColor].CGColor;
            self.quartoView.pickedPieceView.layer.shadowColor = [UIColor quartoBlue].CGColor;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[QuartoPiece class]]) {
        CGPoint cp;
        if ([self.quartoView hasAPieceInPickedPieceView]) {
            cp = [touch locationInView:self.quartoView.pickedPieceView];
            [self.quartoView bringSubviewToFront:self.quartoView.pickedPieceView];
            
        } else {
//            cp = [touch locationInView:self.quartoView.piecesView.pieces[self.pieceIndex]];
//            [self.quartoView bringSubviewToFront:touchedView];
        }
        // Makes the center of the object that was touched to the moved place with the same displacement as where it was calculated earlier.
        touch.view.center = CGPointMake(cp.x, cp.y-touch.view.frame.size.height / 2.f);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchReleasePoint = [touch locationInView:self.view];
    touchReleasePoint = CGPointMake(touchReleasePoint.x, touchReleasePoint.y - touch.view.frame.size.height / 2.f);
    UIView *checkEndView = [self.quartoView hitTest:touchReleasePoint withEvent:nil];
    if ([touch.view isKindOfClass:[QuartoPiece class]])
    {
        // The released touch is on pickedPieceView
        if ([checkEndView isEqual:self.quartoView.pickedPieceView])
        {
            BOOL canPutBoardPiece = [self.quartoView putBoardPieceIntoPickedPieceView:(QuartoPiece *) touch.view];
            if (canPutBoardPiece) {
                touch.view.center = CGPointMake(self.quartoView.pickedPieceView.frame.size.width/2.f, self.quartoView.pickedPieceView.frame.size.width/2.f);
                
                // Cancel all user interactions.
                for (QuartoPiece *eachPiece in self.quartoView.piecesView.pieces) {
                    eachPiece.userInteractionEnabled = NO;
                }
                
                // Except for the piece that is in pickedPieceView
                touch.view.userInteractionEnabled = YES;
    
                // If first player made the move, then now it's second player's turn.
                if (CGColorEqualToColor([UIColor quartoBlue].CGColor, self.quartoView.nameLabel1.layer.borderColor)) {
//                    NSNumber *moveIndexForBot = [self.bot botMovedAtIndexWithBoard:[self.quartoView.boardView getBoard] pickedPiece:self.quartoView.pickedPieceViewIndex];
                    
                    // Change border highlight
                    self.quartoView.nameLabel1.layer.borderColor = [UIColor clearColor].CGColor;
                    self.quartoView.nameLabel2.layer.borderColor = [UIColor quartoBlue].CGColor;
                } else {
                    
                    // Change border highlight
                    self.quartoView.nameLabel1.layer.borderColor = [UIColor quartoBlue].CGColor;
                    self.quartoView.nameLabel2.layer.borderColor = [UIColor clearColor].CGColor;
                }
                
            } else {
                touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
            }
        }
        
        // The release touch is on a QuartoBoardViewCell.
        else if ([checkEndView isKindOfClass:[QuartoBoardViewCell class]] && [self.quartoView hasAPieceInPickedPieceView])
        {
            QuartoBoardViewCell *endView = (QuartoBoardViewCell *) checkEndView;
            BOOL canPutBoardPiece = [endView putBoardPiece:(QuartoPiece *) touch.view];
            if (canPutBoardPiece) {
                touch.view.center = CGPointMake(endView.frame.size.width/2.f, endView.frame.size.width/2.f);
                [self.quartoView removePieceFromPickedPieceView];
                for (QuartoPiece *eachPiece in self.quartoView.piecesView.pieces) {
                    eachPiece.userInteractionEnabled = YES;
                }
                
                if (self.showGameGuides) {
                    self.quartoView.boardView.layer.shadowColor = [UIColor blackColor].CGColor;
                    self.quartoView.piecesView.layer.shadowColor = [UIColor quartoBlue].CGColor;
                    self.shownGameGuidesCount++;
                    if (self.shownGameGuidesCount == 2) {
                        self.showGameGuides = NO;
                        self.quartoView.piecesView.layer.shadowColor = [UIColor blackColor].CGColor;
                    }
                }
            } else {
                touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
            }
        }
        
        // The release touch is invalid.
        else
        {
            touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
        }
        
        touch.view.layer.zPosition = 0;
    }
}

@end










