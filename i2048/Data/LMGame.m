//
//  LMGame.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMGame.h"

#import "LMBoard.h"

@interface LMGame ()

@property (nonatomic, strong) LMBoard *board;

@end

@implementation LMGame

- (instancetype)initWithBoard:(LMBoard *)board;
{
    self = [super init];
    if (self)
    {
        self.board = board;
    }
    return self;
}

#pragma mark - Public Interface

- (BOOL)canShiftUp
{
    return ![self.board isRowFull:0];
}

- (BOOL)canShiftDown
{
    return ![self.board isRowFull:self.board.size - 1];
}

- (BOOL)canShiftLeft
{
    return ![self.board isColumnFull:0];
}

- (BOOL)canShiftRight
{
    return ![self.board isColumnFull:self.board.size - 1];
}

- (void)shiftUp
{
    
}

- (void)shiftDown
{
    
}

- (void)shiftLeft
{
    
}

- (void)shiftRight
{
    
}

- (BOOL)isOver
{
    return [self.board isFull] && ![self hasMatches];
}

#pragma mark - Private Utility

- (BOOL)hasMatches
{
    return NO;
}

@end
