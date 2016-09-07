//
//  QuartoView.h
//  QuartoAI
//
//  Created by Aung Moe on 8/25/16.
//  Copyright © 2016 Aung Moe. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, SettingsButton){
//    SettingsButtonQuit,
//    SettingsButtonRestart
//};

@class QuartoBoardView, QuartoPiecesView, QuartoPiece, CustomIOSAlertView, QuartoSettingsView;

@interface QuartoView : UIView

#pragma mark - Name Labels
@property (nonatomic, strong) UILabel *nameLabel1;
@property (nonatomic, strong) UILabel *nameLabel2;

#pragma mark - Settings
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) CustomIOSAlertView *customIOSAlertView;
@property (nonatomic, strong) QuartoSettingsView *settingsView;

#pragma mark - Views and variables
@property (nonatomic, strong) QuartoBoardView *boardView;
@property (nonatomic, strong) UIView *pickedPieceView;
@property (nonatomic, strong) QuartoPiecesView *piecesView;
@property (nonatomic, strong) NSNumber *pickedPieceViewIndex;

#pragma mark - Init Using This
- (instancetype)initWithFirstPlayerName:(NSString *)firstPlayerName secondPlayerName:(NSString *)secondPlayerName;

#pragma mark - PickedPiece View Methods
- (BOOL)putBoardPieceIntoPickedPieceView:(QuartoPiece *)imageView;
- (void)removePieceFromPickedPieceView;
- (BOOL)hasAPieceInPickedPieceView;

#pragma mark - Button hit
//@property (nonatomic, copy) void (^buttonHit)(SettingsButton type);

@end
