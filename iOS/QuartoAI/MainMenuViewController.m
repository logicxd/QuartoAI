//
//  MainMenuViewController.m
//  QuartoAI
//
//  Created by Aung Moe on 8/24/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainMenuView.h"

@interface MainMenuViewController()
@property (nonatomic, strong) MainMenuView *mainMenu;
@end

@implementation MainMenuViewController

- (void)loadView {
    self.mainMenu = [[MainMenuView alloc] init];
    self.view = self.mainMenu;
}

- (void)viewDidLoad {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"How to Play"
                                                                   message:@"Win by connecting four in a row of the same attribute: tall or short, round or circle, has a hole or no hole, white or black.\nPlace a piece on the board, and then pick a piece for the opponent to play."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Got it!"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //This is called when the person presses "Got it!" button.
                                                          }];
    [alert addAction:defaultAction];
    
    __weak typeof(self) weakSelf = self;
    self.mainMenu.buttonHit = ^(MainMenuButtonType type) {
        if (type == MainMenuButtonTypePlayerVsPlayer) {
            
        } else if (type == MainMenuButtonTypePlayerVsBot) {
            
        } else if (type == MainMenuButtonTypeHowTo) {
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
    };
}

@end
