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
    [self.game removeObserver:self forKeyPath:@"score"];
}

- (id)initWithBoard:(LMBoard *)board
{
    self = [super initWithNibName:@"LMGameViewController" bundle:nil];
    if (self)
    {
        self.game = [[LMGame alloc] initWithBoard:board];
        [self.game addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = UIRectEdgeNone;
    
    self.boardView.board = self.game.board;
}

- (IBAction)pressedLeft:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftLeft]];
}

- (IBAction)pressedRight:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftRight]];
}

- (IBAction)pressedUp:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftUp]];
}

- (IBAction)pressedDown:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.game shiftDown]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"score"])
    {
        self.scoreLabel.text = [NSString stringWithFormat:@"%u", self.game.score];
    }
}

@end
