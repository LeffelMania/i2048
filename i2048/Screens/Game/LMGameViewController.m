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

@interface LMGameViewController ()

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet LMBoardView *boardView;

@property (nonatomic, strong) LMGame *game;

@end

@implementation LMGameViewController

- (void)dealloc
{
    [self stopListeningToGame];
}

- (id)initWithBoard:(LMBoard *)board
{
    self = [super initWithNibName:@"LMGameViewController" bundle:nil];
    if (self)
    {
        self.game = [[LMGame alloc] initWithBoard:board];
        [self startListeningToGame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = UIRectEdgeNone;
    
    self.boardView.board = self.game.board;
}

- (IBAction)swipedLeft:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftLeft]];
}

- (IBAction)swipedRight:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftRight]];
}

- (IBAction)swipedUp:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftUp]];
}

- (IBAction)swipedDown:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftDown]];
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
        self.scoreLabel.text = [NSString stringWithFormat:@"%u", self.game.score];
    }
}

@end
