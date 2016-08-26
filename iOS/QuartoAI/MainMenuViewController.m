//
//  MainMenuViewController.m
//  QuartoAI
//
//  Created by Aung Moe on 8/24/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainMenuView.h"
#import "QuartoViewController.h"

@interface MainMenuViewController()
@property (nonatomic, strong) MainMenuView *mainMenuView;
@property (nonatomic, strong) QuartoViewController *playerVsPlayerViewController;
@property (nonatomic, strong) QuartoViewController *playerVsBotViewController;
@end

@implementation MainMenuViewController

- (void)loadView {
    self.mainMenuView = [[MainMenuView alloc] init];
    self.view = self.mainMenuView;
}

- (void)viewDidLoad {
    // "Player vs Player"
    self.playerVsPlayerViewController = [[QuartoViewController alloc] initWithIsPlayerVsPlayer:YES];
    
    // "Player vs Bot"
    self.playerVsBotViewController = [[QuartoViewController alloc] initWithIsPlayerVsPlayer:NO];
    
    // "How to Play" button pop up.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"How to Play"
                                                                   message:@"Win by connecting four in a row of the same attribute: tall or short, round or circle, has a hole or no hole, white or black.\nPlace a piece on the board, and then pick a piece for the opponent to play."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Got it!"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //This is called when the person presses "Got it!" button.
                                                          }];
    [alert addAction:defaultAction];
    
    // Button hit.
    __weak typeof(self) weakSelf = self;
    self.mainMenuView.buttonHit = ^(MainMenuButtonType type) {
        if (type == MainMenuButtonTypePlayerVsPlayer) {
            weakSelf.playerVsPlayerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            weakSelf.playerVsPlayerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:weakSelf.playerVsPlayerViewController animated:YES completion:nil];
        } else if (type == MainMenuButtonTypePlayerVsBot) {
            weakSelf.playerVsBotViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            weakSelf.playerVsBotViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:weakSelf.playerVsBotViewController animated:YES completion:nil];
        } else if (type == MainMenuButtonTypeHowTo) {
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    };
}

@end
