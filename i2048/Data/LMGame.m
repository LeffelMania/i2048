//
//  LMGame.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMGame.h"

#import "LMBoard.h"
#import "LMBoardItem.h"
#import "LMShiftResult.h"

@interface LMGame ()

@property (nonatomic, strong) LMBoard *board;
@property (nonatomic, assign) NSUInteger score;

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

- (LMBoardItem *)shiftUp
{
    if (![self.board canShiftUp])
    {
        return nil;
    }
    
    LMShiftResult *result = [self.board shiftUp];
    [self updateScoreWithResult:result];
    
    return result.addedItem;
}

- (LMBoardItem *)shiftDown
{
    if (![self.board canShiftDown])
    {
        return nil;
    }
    
    LMShiftResult *result = [self.board shiftDown];
    [self updateScoreWithResult:result];
    
    return result.addedItem;
}

- (LMBoardItem *)shiftLeft
{
    if (![self.board canShiftLeft])
    {
        return nil;
    }
    
    LMShiftResult *result = [self.board shiftLeft];
    [self updateScoreWithResult:result];
    
    return result.addedItem;
}

- (LMBoardItem *)shiftRight
{
    if (![self.board canShiftRight])
    {
        return nil;
    }
    
    LMShiftResult *result = [self.board shiftRight];
    [self updateScoreWithResult:result];
    
    return result.addedItem;
}

- (BOOL)isOver
{
    return [self.board isFull] && ![self.board hasMatches];
}

#pragma mark - Private Interface

- (void)updateScoreWithResult:(LMShiftResult *)result
{
    NSUInteger score = self.score;
    for (LMBoardItem *item in result.matchedItems)
    {
        score += item.value;
    }
    
    self.score = score;
}

@end
