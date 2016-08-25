//
//  GameViewController.m
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "QuartoViewController.h"
#import "QuartoView.h"

CGPoint firstTouchPoint;    // Saves the location of the first touch.
float xDistanceTouchPoint;  // X distance between img center and firstTouchPointer.center.
float yDistanceTouchPoint;  // Y distance between img center and firstTouchPointer.center.

@interface QuartoViewController ()
@property (nonatomic, strong) QuartoView *quartoView;
@end

@implementation QuartoViewController

- (instancetype)initWithIsPlayerVsPlayer:(BOOL)isPlayerVsPlayer {
    if (self = [super init]) {
        
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
    if ([touch.view isEqual:self.quartoView.imgView]) {
        NSLog(@"Touch Began");
        // The location of where the object was touched.
        firstTouchPoint = [touch locationInView:self.view];
        
        // The X-axis difference between where the object was touched from the object's center.
        xDistanceTouchPoint = firstTouchPoint.x - touch.view.center.x;
        
        // The Y-axis difference between where the object was touched from the object's center.
        yDistanceTouchPoint = firstTouchPoint.y - touch.view.center.y;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.quartoView.imgView]) {
        // The location where the object was moved.
        CGPoint cp = [touch locationInView:self.view];
        
        // Makes the center of the object that was touched to the moved place with the same displacement as where it was calculated earlier.
        touch.view.center = CGPointMake(cp.x-xDistanceTouchPoint, cp.y-yDistanceTouchPoint);
    }
}

@end