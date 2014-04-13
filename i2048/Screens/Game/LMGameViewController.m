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
#import "LMShiftResult.h"

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
    LMShiftResult *result = [self.board shiftLeft];
    [self.boardView updateWithShiftResult:result];
}

- (IBAction)pressedRight:(id)sender
{
    LMShiftResult *result = [self.board shiftRight];
    [self.boardView updateWithShiftResult:result];
}

- (IBAction)pressedUp:(id)sender
{
    LMShiftResult *result = [self.board shiftUp];
    [self.boardView updateWithShiftResult:result];
}

- (IBAction)pressedDown:(id)sender
{
    LMShiftResult *result = [self.board shiftDown];
    [self.boardView updateWithShiftResult:result];
}

@end
