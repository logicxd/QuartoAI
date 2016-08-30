//
//  QuartoView.h
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuartoBoardView, QuartoPiecesView;

@interface QuartoView : UIView
@property (nonatomic, strong) QuartoBoardView *boardView;
@property (nonatomic, strong) QuartoPiecesView *piecesView;
@end
