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

// Variables for drag and drop.
@property (nonatomic, assign) CGPoint firstTouchPoint;      // Saves the location of the first touch.
@property (nonatomic, assign) NSNumber *pieceIndex;         // The index of the touched piece.
@property (nonatomic, strong) UIView *dragFromPiecesView;             // The view that is being dragged.
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
    if (self.isPlayerVsPlayer) {
        _quartoView = [[QuartoView alloc] initWithFirstPlayerName:@"Player 1" secondPlayerName:@"Player 2"];
    } else {
        _quartoView = [[QuartoView alloc] initWithFirstPlayerName:@"Player" secondPlayerName:@"Bot"];
    }
    _showGameGuides = YES;
    _shownGameGuidesCount = 0;
    
    if (self.showGameGuides) {
        self.quartoView.piecesView.layer.shadowColor = [UIColor quartoBlue].CGColor;
    }
    
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
        
        // Initialize variables for drag and drop.
        _firstTouchPoint = [touch locationInView:self.view];
        _pieceIndex = [((QuartoPiece *) touch.view) pieceIndex];
        _dragFromPiecesView = [self.quartoView.piecesView getTheSlotThatThePieceIsInWithIndex:self.pieceIndex];
        _xDistanceTouchPoint = self.firstTouchPoint.x - touch.view.center.x;
        _yDistanceTouchPoint = self.firstTouchPoint.y - touch.view.center.y;
        
        // Make the object on top of other views.
        if ([self.quartoView hasAPieceInPickedPieceView]) {
            self.quartoView.pickedPieceView.layer.zPosition = MAXFLOAT;
            self.quartoView.piecesView.layer.zPosition = 0;
        } else {
            self.quartoView.pickedPieceView.layer.zPosition = 0;
            self.quartoView.piecesView.layer.zPosition = MAXFLOAT;
            self.dragFromPiecesView.layer.zPosition = MAXFLOAT;
        }
        
        // Highlight shadow to show what to do next.
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
        
        // Get the location of the finger relative to the initial touch.
        CGPoint centerPoint;
        if ([self.quartoView hasAPieceInPickedPieceView]) {
            centerPoint = [touch locationInView:self.quartoView.pickedPieceView];
        } else {
            centerPoint = [touch locationInView:self.dragFromPiecesView];
        }
        
        // Make the view centered on the finger and shifted up.
        touch.view.center = CGPointMake(centerPoint.x, centerPoint.y-touch.view.frame.size.height / 2.f);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    // Get the location where the finger was lifted.
    CGPoint touchReleasePoint = [touch locationInView:self.view];
    touchReleasePoint = CGPointMake(touchReleasePoint.x, touchReleasePoint.y - touch.view.frame.size.height / 2.f);
    
    // The view underneath where the finger was lifted.
    UIView *checkEndView = [self.quartoView hitTest:touchReleasePoint withEvent:nil];
    
    if ([touch.view isKindOfClass:[QuartoPiece class]])
    {
        
        // Placing the piece into pickedPieceView.
        if ([checkEndView isEqual:self.quartoView.pickedPieceView])
        {
            
            BOOL canPutBoardPiece = [self.quartoView putBoardPieceIntoPickedPieceView:(QuartoPiece *) touch.view];
            if (canPutBoardPiece) {
                
                // Put the piece in the pickedPieceView.
                touch.view.center = CGPointMake(self.quartoView.pickedPieceView.frame.size.width/2.f,
                                                self.quartoView.pickedPieceView.frame.size.width/2.f);
                
                // Disable touch to the pieces in the piecesView.
                for (QuartoPiece *eachPiece in self.quartoView.piecesView.pieces) {
                    eachPiece.userInteractionEnabled = NO;
                }
                
                // Enable the touch that is placed into pickedPieceView.
                touch.view.userInteractionEnabled = YES;
    
                
                /* 
                 Finish up the game and switch to the next player.
                 This checks for who's turn it is based on the color of name labels.
                 */
                // NameLabel1 made the move. NameLabel2's turn.
                if (CGColorEqualToColor([UIColor quartoBlue].CGColor, self.quartoView.nameLabel1.layer.borderColor))
                {
                    if (!self.isPlayerVsPlayer) {
//                        NSNumber *moveIndexForBot = [self.bot botMovedAtIndexWithBoard:[self.quartoView.boardView getBoard]
//                                                                           pickedPiece:self.quartoView.pickedPieceViewIndex];
                    }
                    
                    // Change border highlight.
                    self.quartoView.nameLabel1.layer.borderColor = [UIColor clearColor].CGColor;
                    self.quartoView.nameLabel2.layer.borderColor = [UIColor quartoBlue].CGColor;
                }
                
                // NameLabel2 made the move. NameLabel1's turn.
                else
                {
                    
                    
                    // Change border highlight.
                    self.quartoView.nameLabel1.layer.borderColor = [UIColor quartoBlue].CGColor;
                    self.quartoView.nameLabel2.layer.borderColor = [UIColor clearColor].CGColor;
                }
                
            } else {
                
                // Put the piece back where it was.
                touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
            }
        }
        
        // Placing the piece on the board.
        else if ([checkEndView isKindOfClass:[QuartoBoardViewCell class]] && [self.quartoView hasAPieceInPickedPieceView])
        {
            
            // Get the slot on board where the piece was put.
            QuartoBoardViewCell *endView = (QuartoBoardViewCell *) checkEndView;
            
            BOOL canPutBoardPiece = [endView putBoardPiece:(QuartoPiece *) touch.view];
            if (canPutBoardPiece) { 
                
                // Put the piece in the slot.
                touch.view.center = CGPointMake(endView.frame.size.width/2.f,
                                                endView.frame.size.width/2.f);
                
                // Remove the piece in pickedPieceView.
                [self.quartoView removePieceFromPickedPieceView];
                
                // Check for winner.
                NSArray<NSNumber *> *winningIndicies;
                if ((winningIndicies = [QuartoAI winningIndiciesWithBoard:[self.quartoView.boardView getBoard]])){
                    
                    // Get winner's name.
                    NSString *nameOfTheWinner;
                    if (CGColorEqualToColor([UIColor quartoBlue].CGColor, self.quartoView.nameLabel1.layer.borderColor)) {
                        nameOfTheWinner = self.quartoView.nameLabel1.text;
                    } else {
                        nameOfTheWinner = self.quartoView.nameLabel2.text;
                    }
                    
                    NSLog(@"Winner is: %@", nameOfTheWinner);
                    
                    // Highlight winning indicies.
                    __block CGFloat timer = 0.4;
                    for (NSNumber *eachIndex in winningIndicies) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (timer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.quartoView.boardView.boardCells[eachIndex.integerValue].layer.borderColor = [UIColor quartoWhite].CGColor;
                        });
                        timer += 0.4;
                        NSLog(@"timer: %f", timer);
                    }
                    
                } else {
                    
                    // Enable touch for all the pieces in piecesView.
                    for (QuartoPiece *eachPiece in self.quartoView.piecesView.pieces) {
                        eachPiece.userInteractionEnabled = YES;
                    }
                }
                
                // Highlight to show what to do next.
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
                
                // Put the piece back where it was.
                touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
            }
        }
        
        // The release touch is invalid.
        else
        {
            touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
        }
        
        self.dragFromPiecesView.layer.zPosition = 0;
    }
}

@end










