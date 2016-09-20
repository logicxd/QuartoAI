//
//  GameViewController.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "MainMenuViewController.h"
#import "QuartoViewController.h"
#import "QuartoView.h"
#import "QuartoBoardView.h"
#import "QuartoBoardViewCell.h"
#import "QuartoPiecesView.h"
#import "QuartoPiece.h"
#import "QuartoAI.h"
#import "QuartoSettingsView.h"
#import "CustomIOSAlertView.h"
#import "UIColor+QuartoColor.h"

@interface QuartoViewController ()
// Variables for drag and drop.
@property (nonatomic, assign) CGPoint firstTouchPoint;      // Saves the location of the first touch.
@property (nonatomic, assign) NSNumber *pieceIndex;         // The index of the touched piece.
@property (nonatomic, strong) UIView *dragFromPiecesView;   // The view that is being dragged.
@property (nonatomic, assign) float xDistanceTouchPoint;    // X distance between img center and firstTouchPointer.center.
@property (nonatomic, assign) float yDistanceTouchPoint;    // Y distance between img center and firstTouchPointer.center.

// Game View
@property (nonatomic, strong) QuartoView *quartoView;
@property (nonatomic, assign) BOOL showGameGuides;                  // Highlights the shadows to indicate what to do.
@property (nonatomic, assign) NSInteger shownGameGuidesCount;       // Stops highlighting after two rounds.

// Bot Interactions
@property (nonatomic, assign) BOOL isPlayerVsPlayer;
@property (nonatomic, strong) QuartoAI *bot;
@end

@implementation QuartoViewController

#pragma mark - Init

- (instancetype)initWithIsPlayerVsPlayer:(BOOL)isPlayerVsPlayer {
    if (self = [super init]) {
        _isPlayerVsPlayer = isPlayerVsPlayer;
    }
    return self;
}

#pragma mark - Loading Views

- (void)loadView {
    
    // Initialize Game View properties.
    _quartoView = self.isPlayerVsPlayer ? [[QuartoView alloc] initWithFirstPlayerName:@"Player 1" secondPlayerName:@"Player 2"] :
                                          [[QuartoView alloc] initWithFirstPlayerName:@"Player" secondPlayerName:@"Bot"];
    _showGameGuides = NO;           // Set to YES to show hints
    _shownGameGuidesCount = 0;
    
    // Set some initial view settings.
    if (self.showGameGuides) {
        self.quartoView.piecesView.layer.shadowColor = [UIColor quartoBlue].CGColor;
    }
    self.quartoView.nameLabel1.layer.borderColor = [UIColor quartoBlue].CGColor;
    self.view = self.quartoView;
}

- (void)viewDidLoad {
    
    // After the view loads, start setting the bot.
    _bot = [[QuartoAI alloc] init];
    
    // Button hit for "Settings"
    __weak typeof(self) weakSelf = self;
    self.quartoView.settingsView.buttonHit = ^(SettingsButton type) {
        
         if (type == SettingsButtonRestart) {
             NSLog(@"\"Restart\" is pressed");
             [weakSelf.quartoView.customIOSAlertView close];
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf resetGame];
             });
         }
        
         else if (type == SettingsButtonQuit) {
             NSLog(@"\"Quit\" is pressed");
             [weakSelf.quartoView.customIOSAlertView close];
             
             __block MainMenuViewController *mainMenu = [[MainMenuViewController alloc] init];
             mainMenu.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
             mainMenu.modalPresentationStyle = UIModalPresentationFullScreen;
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf presentViewController:mainMenu animated:YES completion:nil];
             });
         }
    };
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
                
                // Disable touch to the pieces in the piecesView.
                for (QuartoPiece *eachPiece in self.quartoView.piecesView.pieces) {
                    eachPiece.userInteractionEnabled = NO;
                }
    
                /* 
                 Finish up the game and switch to the next player.
                 This checks for who's turn it is based on the color of name labels.
                 */
                // NameLabel1 made the move. NameLabel2's turn.
                if (CGColorEqualToColor([UIColor quartoBlue].CGColor, self.quartoView.nameLabel1.layer.borderColor))
                {
                    if (!self.isPlayerVsPlayer) {
                        
                       [self playBot];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                                       ^{
                                           if (![self canHighlightWinningIndicies]) {
                                               
                                               // Change border highlight.
                                               self.quartoView.nameLabel1.layer.borderColor = [UIColor quartoBlue].CGColor;
                                               self.quartoView.nameLabel2.layer.borderColor = [UIColor clearColor].CGColor;
                                           } else {
                                               
                                               self.quartoView.pickedPieceView.userInteractionEnabled = NO;
                                           }
                                       });
                    } else {
                        
                        // Enable the touch that is placed into pickedPieceView.
                        touch.view.userInteractionEnabled = YES;
                    }
                    
                    // Change border highlight.
                    self.quartoView.nameLabel1.layer.borderColor = [UIColor clearColor].CGColor;
                    self.quartoView.nameLabel2.layer.borderColor = [UIColor quartoBlue].CGColor;
                }
                
                // NameLabel2 made the move. NameLabel1's turn.
                else
                {
                    
                    // Enable the touch that is placed into pickedPieceView.
                    touch.view.userInteractionEnabled = YES;
                    
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
                
                // Check for winner and highligh
                if (![self canHighlightWinningIndicies]) {
                    
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

#pragma mark - Bot Interactions

- (void)playBot {
    
    NSDictionary *botDecision = [self.bot botMovedAtIndexWithBoard:[self.quartoView.boardView getBoard]
                                                       pickedPiece:self.quartoView.pickedPieceViewIndex];
    
    NSInteger botPicksPlace = [botDecision[@"place"] integerValue];
    NSInteger botPicksPiece = [botDecision[@"piece"] integerValue];
    NSInteger botPicksPieceSlot = [[self.quartoView.piecesView getSlotPositionOfPieceIndex:@(botPicksPiece)] integerValue];
    
    // IMPORTANT: 'Piece' and 'Piece slots' are DIFFERENT. Piece slots are the visible slots that you see on the screen.
    // Each piece slots can hold a piece that are randomized.
    
    // Instead of drag-and-drop animation, you can try changing opacity.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.quartoView.boardView.boardCells[botPicksPlace] putBoardPiece:[[self.quartoView.pickedPieceView subviews] firstObject]];
        [self.quartoView removePieceFromPickedPieceView];
    });
    
    __block QuartoPiece *piece;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        piece = [self.quartoView.piecesView removePieceAtSlot:botPicksPieceSlot];
        [self.quartoView putBoardPieceIntoPickedPieceView:piece];
    });
    
    NSLog(@"Bot places index: %ld   Picks piece index: %ld",
          (long) botPicksPlace,
          (long) botPicksPieceSlot
          );
}

- (BOOL)canHighlightWinningIndicies {
    
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
        }
    }
    
    return winningIndicies ? YES : NO;
}

- (void)resetGame {
    [self.quartoView.boardView resetBoard];
    [self.quartoView removePieceFromPickedPieceView];
    [self.quartoView.piecesView resetBoard];
    
    // Make a method for this.
    self.quartoView.nameLabel1.layer.borderColor = [UIColor quartoBlue].CGColor;
    self.quartoView.nameLabel2.layer.borderColor = [UIColor quartoBlack].CGColor;
}

@end










