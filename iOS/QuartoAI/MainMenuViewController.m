//
//  MainMenuViewController.m
//  QuartoAI
//
//  Created by Aung Moe on 8/24/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainMenuView.h"

@implementation MainMenuViewController

- (void)loadView {
    self.view = [[MainMenuView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSLog(@"MainMenuView width: %f height: %f", self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewDidLoad {
    
}

@end
