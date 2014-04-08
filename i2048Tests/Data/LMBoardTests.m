//
//  LMBoardTests.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LMBoard.h"
#import "LMBoardItem.h"

@interface LMBoardTests : XCTestCase

@end

@implementation LMBoardTests

- (void)testDescriptionDoesntCrash
{
    NSArray *values = @[
                        @(1)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:1 values:values];
    
    NSLog(@"%@", board);
}

- (void)testEdgeCases
{
    NSArray *values = @[
                        @(4)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:1 values:values];
    
    LMBoardItem *item = [board itemAtRow:1000 column:0];
    XCTAssert(item == nil, @"Out-of-bounds row item wasn't nil");
    
    item = [board itemAtRow:0 column:1000];
    XCTAssert(item == nil, @"Out-of-bounds column item wasn't nil");
    
    [board shiftRight];
    item = [board itemAtRow:0 column:0];
    XCTAssert(item.level == 4, @"Insertion of new item on full board edited board");
}

- (void)testIndexItemFetch
{
    NSArray *values = @[
                        @(1), @(2),
                        @(3), @(4)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    for (NSUInteger row = 0; row < 2; row++)
    {
        for (NSUInteger col = 0; col < 2; col++)
        {
            NSUInteger index = (row * 2) + col;
            
            LMBoardItem *item = [board itemAtRow:row column:col];
            XCTAssert(item.level == [values[index] unsignedIntegerValue], @"Board iteration failed at index %u; expected %@, got %u", index, values[index], item.level);
        }
    }
}

#pragma mark - Shift Up

- (void)testCanShiftUpReturnsFalseWhenTopRowIsFull
{
    NSArray *values = @[
                        @(1), @(2),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftUp], @"Can't shift up if top row is full");
}

- (void)testCanShiftUpReturnsFalseWhenUnfilledColumnIsEmpty
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftUp], @"Can't shift up if unfilled column is empty");
}

- (void)testCanShiftUpReturnsTrue
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty),
                        @(1), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert([board canShiftUp], @"Couldn't shift up");
}

- (void)testShiftUpMovesItemValues
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty),
                        @(1), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftUp];
    
    LMBoardItem *item = [board itemAtRow:0 column:0];
    XCTAssert(item.level == 1, @"Shift up didn't move item");
}

- (void)testShiftUpConsolidatesMatches
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(1), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftUp];
    
    LMBoardItem *item = [board itemAtRow:0 column:0];
    XCTAssert(item.level == 2, @"Shift up didn't consolidate pair");
}

- (void)testShiftUpInsertsNewItem
{
    NSArray *values = @[
                        @(4), @(LMBoardItemEmpty),
                        @(5), @(6)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftUp];
    
    LMBoardItem *item = [board itemAtRow:1 column:1];
    XCTAssert(item.level == 1, @"Shift up didn't insert new item");
}

#pragma mark - Shift Down

- (void)testCanShiftDownReturnsFalseWhenBottomRowIsFull
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty),
                        @(1), @(2)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftDown], @"Can't shift down if bottom row is full");
}

- (void)testCanShiftDownReturnsFalseWhenUnfilledColumnIsEmpty
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty),
                        @(1), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftDown], @"Can't shift down if unfilled column is empty");
}

- (void)testCanShiftDownReturnsTrue
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert([board canShiftDown], @"Couldn't shift down");
}

- (void)testShiftDownMovesItemValues
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftDown];
    
    LMBoardItem *item = [board itemAtRow:1 column:0];
    XCTAssert(item.level == 1, @"Shift up didn't move item");
}

- (void)testShiftDownConsolidatesMatches
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(1), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftDown];
    
    LMBoardItem *item = [board itemAtRow:1 column:0];
    XCTAssert(item.level == 2, @"Shift up didn't consolidate pair");
}

- (void)testShiftDownInsertsNewItem
{
    NSArray *values = @[
                        @(4), @(6),
                        @(5), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftDown];
    
    LMBoardItem *item = [board itemAtRow:0 column:1];
    XCTAssert(item.level == 1, @"Shift up didn't insert new item");
}

#pragma mark - Shift Left

- (void)testCanShiftLeftReturnsFalseWhenFirstColumnIsFull
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(2), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftLeft], @"Can't shift left if first column is full");
}

- (void)testCanShiftLeftReturnsFalseWhenUnfilledRowIsEmpty
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty),
                        @(1), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftLeft], @"Can't shift left if unfilled row is empty");
}

- (void)testCanShiftLeftReturnsTrue
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(1),
                        @(2), @(3)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert([board canShiftLeft], @"Couldn't shift left");
}

- (void)testShiftLeftMovesItemValues
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(1),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftLeft];
    
    LMBoardItem *item = [board itemAtRow:0 column:0];
    XCTAssert(item.level == 1, @"Shift up didn't move item");
}

- (void)testShiftLeftConsolidatesMatches
{
    NSArray *values = @[
                        @(1), @(1),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftLeft];
    
    LMBoardItem *item = [board itemAtRow:0 column:0];
    XCTAssert(item.level == 2, @"Shift up didn't consolidate pair");
}

- (void)testShiftLeftInsertsNewItem
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(4),
                        @(5), @(6)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftLeft];
    
    LMBoardItem *item = [board itemAtRow:0 column:1];
    XCTAssert(item.level == 1, @"Shift up didn't insert new item");
}

#pragma mark - Shift Right

- (void)testCanShiftRightReturnsFalseWhenLastColumnIsFull
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(1),
                        @(LMBoardItemEmpty), @(2)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftRight], @"Can't shift right if last column is full");
}

- (void)testCanShiftRightReturnsFalseWhenUnfilledRowIsEmpty
{
    NSArray *values = @[
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty),
                        @(LMBoardItemEmpty), @(1)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board canShiftRight], @"Can't shift right if unfilled row is empty");
}

- (void)testCanShiftRightReturnsTrue
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(2), @(3)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert([board canShiftRight], @"Couldn't shift right");
}

- (void)testShiftRightMovesItemValues
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftRight];
    
    LMBoardItem *item = [board itemAtRow:0 column:1];
    XCTAssert(item.level == 1, @"Shift up didn't move item");
}

- (void)testShiftRightConsolidatesMatches
{
    NSArray *values = @[
                        @(1), @(1),
                        @(LMBoardItemEmpty), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftRight];
    
    LMBoardItem *item = [board itemAtRow:0 column:1];
    XCTAssert(item.level == 2, @"Shift up didn't consolidate pair");
}

- (void)testShiftRightInsertsNewItem
{
    NSArray *values = @[
                        @(4), @(LMBoardItemEmpty),
                        @(5), @(6)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    [board shiftRight];
    
    LMBoardItem *item = [board itemAtRow:0 column:0];
    XCTAssert(item.level == 1, @"Shift up didn't insert new item");
}

#pragma mark - Has Matches

- (void)testHashMatchesReturnsFalseForEmptyBoard
{
    LMBoard *board = [[LMBoard alloc] initWithSize:4];
    
    XCTAssert(![board hasMatches], @"Board shouldn't have had matches");
}

- (void)testHasMatchesReturnsFalseForFilledBoard
{
    NSArray *values = @[
                        @(1), @(LMBoardItemEmpty),
                        @(2), @(3)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board hasMatches], @"Board shouldn't have had matches");
}

- (void)testHasMatchesReturnsTrueForVerticalMatches
{
    NSArray *values = @[
                        @(1), @(2),
                        @(1), @(3)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert([board hasMatches], @"Board should've had matches");
}

- (void)testHasMatchesReturnsTrueForHorizontalMatches
{
    NSArray *values = @[
                        @(1), @(1),
                        @(2), @(3)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert([board hasMatches], @"Board should've had matches");
}

#pragma mark - Is Full

- (void)testIsFullReturnsTrueWhenFull
{
    NSArray *values = @[
                        @(1), @(2),
                        @(3), @(4)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert([board isFull], @"Board did not return that it was full.");
}

- (void)testIsFullReturnsFalseWhenCellIsEmpty
{
    NSArray *values = @[
                        @(1), @(2),
                        @(3), @(LMBoardItemEmpty)
                        ];
    
    LMBoard *board = [[LMBoard alloc] initWithSize:2 values:values];
    
    XCTAssert(![board isFull], @"Board returned that it was full.");
}

@end
