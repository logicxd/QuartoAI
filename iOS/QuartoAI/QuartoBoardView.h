//
//  QuartoBoardView.h
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartoBoardView : UIView

@property (nonatomic, strong) NSMutableArray<UIView *> *board;
- (instancetype)init; // Must use masonry to set constraints.

@end
