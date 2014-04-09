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
    [self.board shiftLeft];
    NSLog(@"%@", self.board);
}

- (IBAction)pressedRight:(id)sender
{
    [self.board shiftRight];
    NSLog(@"%@", self.board);
}

- (IBAction)pressedUp:(id)sender
{
    [self.board shiftUp];
    NSLog(@"%@", self.board);
}

- (IBAction)pressedDown:(id)sender
{
    [self.board shiftDown];
    NSLog(@"%@", self.board);
}

@end
