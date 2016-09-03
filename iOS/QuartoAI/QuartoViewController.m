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


@interface QuartoViewController ()

// Class variables for drag and drop.
@property (nonatomic, assign) CGPoint firstTouchPoint;      // Saves the location of the first touch.
@property (nonatomic, assign) float xDistanceTouchPoint;    // X distance between img center and firstTouchPointer.center.
@property (nonatomic, assign) float yDistanceTouchPoint;    // Y distance between img center and firstTouchPointer.center.

// Handling Views
@property (nonatomic, strong) QuartoView *quartoView;

// Bot Interactions
@property (nonatomic, assign) BOOL isPlayerVsPlayer;
@property (nonatomic, strong) QuartoAI *bot;

@end

@implementation QuartoViewController

- (instancetype)initWithIsPlayerVsPlayer:(BOOL)isPlayerVsPlayer {
    if (self = [super init]) {
        _quartoView = [[QuartoView alloc] init];
        _isPlayerVsPlayer = isPlayerVsPlayer;
        _bot = [[QuartoAI alloc] init];
        
//        if (isPlayerVsPlayer) {
//            [self.bot botMovedAtIndex];
//        }
    }
    return self;
}

- (void)loadView {
    self.view = self.quartoView;
}

- (void)viewDidLoad {
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
        
        // The X-axis difference between where the object was touched from the object's center.
        self.xDistanceTouchPoint = self.firstTouchPoint.x - touch.view.center.x;
        
        // The Y-axis difference between where the object was touched from the object's center.
        self.yDistanceTouchPoint = self.firstTouchPoint.y - touch.view.center.y;
        
        // Make the object on top of other views.
        touch.view.layer.zPosition = 1;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[QuartoPiece class]]) {
        CGPoint cp;
        if ([self.quartoView thereIsAPieceInPickedPieceView]) {
            cp = [touch locationInView:self.quartoView.pickedPieceView];
            [self.quartoView bringSubviewToFront:self.quartoView.pickedPieceView];
        } else {
            // The location where the object was moved.
            cp = [touch locationInView:self.quartoView.piecesView];
            [self.quartoView bringSubviewToFront:self.quartoView.piecesView];
        }
        // Makes the center of the object that was touched to the moved place with the same displacement as where it was calculated earlier.
        touch.view.center = CGPointMake(cp.x, cp.y-touch.view.frame.size.height / 2.f);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchReleasePoint = [touch locationInView:self.view];
    touchReleasePoint = CGPointMake(touchReleasePoint.x, touchReleasePoint.y - touch.view.frame.size.height / 2.f);
    UIView *checkEndView = [self.quartoView hitTest:touchReleasePoint
                                          withEvent:nil];
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
            } else {
                touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
            }
        }
        
        // The release touch is on a QuartoBoardViewCell.
        else if ([checkEndView isKindOfClass:[QuartoBoardViewCell class]] && [self.quartoView thereIsAPieceInPickedPieceView])
        {
            QuartoBoardViewCell *endView = (QuartoBoardViewCell *) checkEndView;
            BOOL canPutBoardPiece = [endView putBoardPiece:(QuartoPiece *) touch.view];
            if (canPutBoardPiece) {
                touch.view.center = CGPointMake(endView.frame.size.width/2.f, endView.frame.size.width/2.f);
                [self.quartoView removePieceFromPickedPieceView];
                for (QuartoPiece *eachPiece in self.quartoView.piecesView.pieces) {
                    eachPiece.userInteractionEnabled = YES;
                }
                
                
            } else {
                touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
            }
        }
        
        // The release touch is invalid.
        else {
            touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
        }
        
        touch.view.layer.zPosition = 0;
    } // End if QuartoPiece
    
}

@end










