//
//  LMGameViewController.m
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMGameViewController.h"

#import "LMBoardView.h"

#import "LMGame.h"

@interface LMGameViewController () <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet LMBoardView *boardView;

@property (nonatomic, strong) LMGame *game;

@end

@implementation LMGameViewController

- (void)dealloc
{
    [self stopListeningToGame];
}

- (id)initWithGame:(LMGame *)game
{
    self = [super initWithNibName:@"LMGameViewController" bundle:nil];
    if (self)
    {
        self.game = game;
        [self startListeningToGame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.boardView.board = self.game.board;
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)swipedLeft:(id)sender
{
    [self updateGameWithItem:[self.game shiftLeft]];
}

- (IBAction)swipedRight:(id)sender
{
    [self updateGameWithItem:[self.game shiftRight]];
}

- (IBAction)swipedUp:(id)sender
{
    [self updateGameWithItem:[self.game shiftUp]];
}

- (IBAction)swipedDown:(id)sender
{
    [self updateGameWithItem:[self.game shiftDown]];
}

#pragma mark - KVO

- (void)startListeningToGame
{
    [self.game addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)stopListeningToGame
{
    [self.game removeObserver:self forKeyPath:@"score"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"score"])
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.game.score];
    }
}

#pragma mark - Private Utility

- (void)updateGameWithItem:(LMBoardItem *)item
{
    [self.boardView updateBoardWithNewItem:item];
    
    if ([self.game isOver])
    {
        self.boardView.userInteractionEnabled = NO;
        [self performSelector:@selector(displayGameOver) withObject:nil afterDelay:.75];
    }
}

- (void)displayGameOver
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!"
                                                    message:[NSString stringWithFormat:@"You scored %lu points before running out of moves!", (unsigned long)self.game.score]
                                                   delegate:self
                                          cancelButtonTitle:@"Neat-O" otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self goBack:nil];
}

@end
