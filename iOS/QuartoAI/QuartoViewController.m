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
@property (nonatomic, strong) UIView *firstTouchView;       // Saves the view of the first touch.
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
        _isPlayerVsPlayer = isPlayerVsPlayer;
        _bot = [[QuartoAI alloc] init];
        
//        if (isPlayerVsPlayer) {
//            [self.bot botMovedAtIndex];
//        }
    }
    return self;
}

- (void)loadView {
    self.quartoView = [[QuartoView alloc] init];
    self.view = self.quartoView;
}

- (void)viewDidLoad {
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _firstTouchView = touch.view;
    if ([touch.view isKindOfClass:[QuartoPiece class]]) {
        NSLog(@"Touch Began");
        // The location of where the object was touched.
        self.firstTouchPoint = [touch locationInView:self.view];
        
        // The X-axis difference between where the object was touched from the object's center.
        self.xDistanceTouchPoint = self.firstTouchPoint.x - touch.view.center.x;
        
        // The Y-axis difference between where the object was touched from the object's center.
        self.yDistanceTouchPoint = self.firstTouchPoint.y - touch.view.center.y;
        
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[QuartoPiece class]]) {
        // The location where the object was moved.
        CGPoint cp = [touch locationInView:self.view];
        
        // Makes the center of the object that was touched to the moved place with the same displacement as where it was calculated earlier.
        touch.view.center = CGPointMake(cp.x-self.xDistanceTouchPoint, cp.y-self.yDistanceTouchPoint);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self.view];
    UIView *checkEndView = [self.quartoView hitTest:endPoint withEvent:nil];
    
    if ([self.firstTouchView isKindOfClass:[QuartoPiece class]] && [checkEndView isKindOfClass:[QuartoBoardViewCell class]]) {
        QuartoBoardViewCell *endView = (QuartoBoardViewCell *) checkEndView;
        
        NSLog(@"Index of board: %i", endView.index);
        BOOL canPutBoardPiece = [endView canPutBoardPiece:(QuartoPiece *) touch.view];
        if (canPutBoardPiece) {
            touch.view.center = CGPointMake(endView.frame.size.width/2.f, endView.frame.size.width/2.f);
        } else {
            touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
        }
    } else if ([touch.view isKindOfClass:[QuartoPiece class]] && self.firstTouchView) {
        touch.view.center = CGPointMake(self.firstTouchPoint.x-self.xDistanceTouchPoint, self.firstTouchPoint.y-self.yDistanceTouchPoint);
    }
}

@end










