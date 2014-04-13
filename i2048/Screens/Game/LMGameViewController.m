//
//  LMGameViewController.m
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMGameViewController.h"

#import "LMBoardView.h"

#import "LMBoard.h"
#import "LMBoardItem.h"

@interface LMGameViewController ()

@property (nonatomic, weak) IBOutlet LMBoardView *boardView;

@property (nonatomic, strong) LMBoard *board;

@end

@implementation LMGameViewController

- (id)initWithBoard:(LMBoard *)board
{
    self = [super initWithNibName:@"LMGameViewController" bundle:nil];
    if (self)
    {
        self.board = board;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.boardView.board = self.board;
}

- (IBAction)pressedLeft:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.board shiftLeft]];
}

- (IBAction)pressedRight:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.board shiftRight]];
}

- (IBAction)pressedUp:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.board shiftUp]];
}

- (IBAction)pressedDown:(id)sender
{
    [self.boardView updateBoardWithNewItem:[self.board shiftDown]];
}

@end
