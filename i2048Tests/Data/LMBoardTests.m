//
//  LMBoardTests.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "LMBoard.h"
#import "LMBoardItem.h"
#import "LMRandom.h"

static LMBoardItemLevel kEmpty = 1234;

@interface LMBoard (Testing)

- (void)setItem:(id)item atRow:(NSUInteger)row column:(NSUInteger)col;

@end

@interface LMBoardTests : XCTestCase

@end

@implementation LMBoardTests

- (void)setUp
{
    [super setUp];
    
    id randomMock = [OCMockObject partialMockForObject:[LMRandom instance]];
    [[[[randomMock stub] ignoringNonObjectArgs] andReturnValue:@(YES)] nextBoolWithChanceOfTrue:0];
}

- (void)testRandomMock
{
    BOOL result = YES;
    for (NSUInteger i = 0; i < 1000; i++)
    {
        result = [[LMRandom instance] nextBoolWithChanceOfTrue:.1f];
        if (!result)
        {
            break;
        }
    }
    
    XCTAssert(result, @"LMRandom stubbed to YES returned a NO");
}

- (LMBoard *)boardWithRows:(NSUInteger)rows columns:(NSUInteger)columns values:(LMBoardItemLevel *)values
{
    LMBoard *board = [[LMBoard alloc] initWithRows:rows columns:columns];
    board.numberOfShiftsPerSeed = 100; // For reliable post-shift board validation
    [self loadBoard:board withValues:values];
    
    return board;
}

- (void)loadBoard:(LMBoard *)board withValues:(LMBoardItemLevel *)values
{
    NSUInteger count = board.rowCount * board.columnCount;
    for (NSUInteger index = 0; index < count; index++)
    {
        NSUInteger row = index / board.columnCount;
        NSUInteger col = index % board.columnCount;
        
        if (values[index] == kEmpty)
        {
            [board setItem:LMBoardItemEmpty atRow:row column:col];
        }
        else
        {
            NSUInteger row = index / board.columnCount;
            NSUInteger col = index % board.columnCount;
            
            LMBoardItem *item = [[LMBoardItem alloc] initWithRow:row column:col level:values[index]];
            [board setItem:item atRow:row column:col];
        }
    }
}

- (void)assertBoard:(LMBoard *)board hasValues:(LMBoardItemLevel *)values
{
    NSUInteger index = 0;
    for (NSUInteger row = 0; row < board.rowCount; row++)
    {
        for (NSUInteger col = 0; col < board.columnCount; col++)
        {
            LMBoardItem *item = [board itemAtRow:row column:col];

            if (values[index] == kEmpty)
            {
                XCTAssert(item == nil, @"Item at %u, %u expected to be nil", row, col);
            }
            else
            {
                XCTAssert(item.row == row, @"Item expected to be at row %u, was at %u", item.row, row);
                XCTAssert(item.column == col, @"Item expected to be at column %u, was at %u", item.column, col);
                XCTAssert(item.level == values[index], @"Item at %u, %u expected to be %u, was %u", row, col, values[index], item.level);
            }
            
            index++;
        }
    }
}

- (void)testDescriptionDoesntCrash
{
    LMBoardItemLevel values[4] = {
        1, 2,
        3, kEmpty
    };
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    NSLog(@"%@", board);
}

- (void)testEdgeCases
{
    LMBoardItemLevel values[1] = {
        4
    };
    
    LMBoard *board = [self boardWithRows:1 columns:1 values:values];
    
    LMBoardItem *item = [board itemAtRow:1000 column:0];
    XCTAssert(item == nil, @"Out-of-bounds row item wasn't nil");
    
    item = [board itemAtRow:0 column:1000];
    XCTAssert(item == nil, @"Out-of-bounds column item wasn't nil");
    
    board.numberOfShiftsPerSeed = 1;
    [board shiftDown];
    item = [board itemAtRow:0 column:0];
    XCTAssert(item.level == 4, @"Shift of full board altered board");
}

- (void)testIndexItemFetch
{
    LMBoardItemLevel values[4] = {
        1, 2,
        3, 4
    };
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    for (NSUInteger row = 0; row < 2; row++)
    {
        for (NSUInteger col = 0; col < 2; col++)
        {
            NSUInteger index = (row * 2) + col;
            
            LMBoardItem *item = [board itemAtRow:row column:col];
            XCTAssert(item.level == values[index], @"Board iteration failed at index %u; expected %u, got %u", index, values[index], item.level);
        }
    }
}

- (void)testConstructorSeedsBoard
{
    LMBoard *board = [[LMBoard alloc] initWithRows:2 columns:2 initialItemCount:4];
    XCTAssert([board isFull], @"Constructed board should have been seeded to capacity");
}

#pragma mark - Shift Up

- (void)testCanShiftUpReturnsFalseWhenTopRowIsFull
{
    LMBoardItemLevel values[2] = {
        1,
        kEmpty,
    };
    LMBoard *board = [self boardWithRows:2 columns:1 values:values];
    
    XCTAssert(![board canShiftUp], @"Can't shift up if top row is full");
}

- (void)testCanShiftUpReturnsFalseWhenUnfilledColumnIsEmpty
{
    LMBoardItemLevel values[4] = {
        1, kEmpty,
        3, kEmpty
    };
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board canShiftUp], @"Can't shift up if unfilled column is empty");
}

- (void)testCanShiftUpReturnsTrue
{
    LMBoardItemLevel values[2] = {
        kEmpty,
        1
    };
    LMBoard *board = [self boardWithRows:2 columns:1 values:values];
    
    XCTAssert([board canShiftUp], @"Couldn't shift up");
}

- (void)testCanShiftUpReturnsTrueForConsolidation
{
    LMBoardItemLevel values[4] = {
        1,
        1,
        kEmpty,
        kEmpty
    };
    
    LMBoard *board = [self boardWithRows:4 columns:1 values:values];
    
    XCTAssert([board canShiftUp], @"Couldn't shift up");
}

- (void)testShiftUpMovesItemValues
{
    LMBoardItemLevel values[4] = {
        kEmpty,
        kEmpty,
        1,
        2,
    };
    LMBoard *board = [self boardWithRows:4 columns:1 values:values];
    
    [board shiftUp];
    
    LMBoardItemLevel result[4] = {
        1,
        2,
        kEmpty,
        kEmpty
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftUpConsolidatesMatches
{
    LMBoardItemLevel values[4] = {
        1,
        kEmpty,
        1,
        3
    };
    
    LMBoard *board = [self boardWithRows:4 columns:1 values:values];
    [board shiftUp];
    
    LMBoardItemLevel result[4] = {
        2,
        3,
        kEmpty,
        kEmpty
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftUpInsertsNewItem
{
    LMBoardItemLevel values[4] = {
        1, kEmpty,
        3, 4
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    board.numberOfShiftsPerSeed = 1;
    
    [board shiftUp];
    
    LMBoardItemLevel result[4] = {
        1, 4,
        3, 0
    };
    
    [self assertBoard:board hasValues:result];
}

#pragma mark - Shift Down

- (void)testCanShiftDownReturnsFalseWhenBottomRowIsFull
{
    LMBoardItemLevel values[2] = {
        kEmpty,
        1
    };
    LMBoard *board = [self boardWithRows:2 columns:1 values:values];
    
    XCTAssert(![board canShiftDown], @"Can't shift down if bottom row is full");
}

- (void)testCanShiftDownReturnsFalseWhenUnfilledColumnIsEmpty
{
    LMBoardItemLevel values[4] = {
        1, kEmpty,
        3, kEmpty
    };
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board canShiftDown], @"Can't shift down if unfilled column is empty");
}

- (void)testCanShiftDownReturnsTrue
{
    LMBoardItemLevel values[2] = {
        1,
        kEmpty
    };
    LMBoard *board = [self boardWithRows:2 columns:1 values:values];
    
    XCTAssert([board canShiftDown], @"Couldn't shift down");
}

- (void)testCanShiftDownReturnsTrueForConsolidation
{
    LMBoardItemLevel values[4] = {
        kEmpty,
        kEmpty,
        1,
        1
    };
    
    LMBoard *board = [self boardWithRows:4 columns:1 values:values];
    
    XCTAssert([board canShiftDown], @"Couldn't shift down");
}

- (void)testShiftDownMovesItemValues
{
    LMBoardItemLevel values[4] = {
        2,
        3,
        kEmpty,
        kEmpty
    };
    LMBoard *board = [self boardWithRows:4 columns:1 values:values];
    
    [board shiftDown];
    
    LMBoardItemLevel result[4] = {
        kEmpty,
        kEmpty,
        2,
        3
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftDownConsolidatesMatches
{
    LMBoardItemLevel values[4] = {
        1,
        1,
        1,
        1
    };
    
    LMBoard *board = [self boardWithRows:4 columns:1 values:values];
    [board shiftDown];
    
    LMBoardItemLevel result[4] = {
        kEmpty,
        kEmpty,
        2,
        2
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftDownInsertsNewItem
{
    LMBoardItemLevel values[4] = {
        1, 2,
        3, kEmpty
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    board.numberOfShiftsPerSeed = 1;
    
    [board shiftDown];
    
    LMBoardItemLevel result[4] = {
        1, 0,
        3, 2
    };
    
    [self assertBoard:board hasValues:result];
}

#pragma mark - Shift Left

- (void)testCanShiftLeftReturnsFalseWhenFirstColumnIsFull
{
    LMBoardItemLevel values[4] = {
        1, kEmpty,
        2, kEmpty
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board canShiftLeft], @"Can't shift left if first column is full");
}

- (void)testCanShiftLeftReturnsFalseWhenUnfilledRowIsEmpty
{
    
    LMBoardItemLevel values[4] = {
        kEmpty, kEmpty,
        1, kEmpty
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board canShiftLeft], @"Can't shift left if unfilled row is empty");
}

- (void)testCanShiftLeftReturnsTrue
{
    
    LMBoardItemLevel values[4] = {
        kEmpty, 1,
        2, 3
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert([board canShiftLeft], @"Couldn't shift left");
}

- (void)testCanShiftLeftReturnsTrueForConsolidation
{
    LMBoardItemLevel values[4] = {
        1, 1, kEmpty, kEmpty
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    
    XCTAssert([board canShiftLeft], @"Couldn't shift left");
}

- (void)testShiftLeftMovesItemValues
{
    LMBoardItemLevel values[4] = {
        1, kEmpty, 2, 1
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    
    [board shiftLeft];
    
    LMBoardItemLevel result[4] = {
        1, 2, 1, kEmpty
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftLeftConsolidatesMatches
{
    LMBoardItemLevel values[4] = {
        1, 1, 2, 2
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    
    [board shiftLeft];
    
    LMBoardItemLevel result[4] = {
        2, 3, kEmpty, kEmpty
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftLeftInsertsNewItem
{
    LMBoardItemLevel values[4] = {
        1, kEmpty, 2, 1
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    board.numberOfShiftsPerSeed = 1;
    
    [board shiftLeft];
    
    LMBoardItemLevel result[4] = {
        1, 2, 1, 0
    };
    
    [self assertBoard:board hasValues:result];
}

#pragma mark - Shift Right

- (void)testCanShiftRightReturnsFalseWhenLastColumnIsFull
{
    LMBoardItemLevel values[4] = {
        kEmpty, 1,
        kEmpty, 2
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board canShiftRight], @"Can't shift right if last column is full");
}

- (void)testCanShiftRightReturnsFalseWhenUnfilledRowIsEmpty
{
    LMBoardItemLevel values[4] = {
        kEmpty, kEmpty,
        kEmpty, 2
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board canShiftRight], @"Can't shift right if unfilled row is empty");
}

- (void)testCanShiftRightReturnsTrue
{
    LMBoardItemLevel values[4] = {
        1, kEmpty,
        2, 3
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert([board canShiftRight], @"Couldn't shift right");
}

- (void)testCanShiftRightReturnsTrueForConsolidation
{
    LMBoardItemLevel values[4] = {
        kEmpty, kEmpty, 1, 1
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    
    XCTAssert([board canShiftRight], @"Couldn't shift right");
}

- (void)testShiftRightMovesItemValues
{
    LMBoardItemLevel values[4] = {
        1, 2, kEmpty, 1,
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    [board shiftRight];
    
    LMBoardItemLevel result[4] = {
        kEmpty, 1, 2, 1
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftRightConsolidatesMatches
{
    LMBoardItemLevel values[4] = {
        2, 2, 1, 1,
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    [board shiftRight];
    
    LMBoardItemLevel result[4] = {
        kEmpty, kEmpty, 3, 2
    };
    
    [self assertBoard:board hasValues:result];
}

- (void)testShiftRightInsertsNewItem
{
    LMBoardItemLevel values[4] = {
        1, kEmpty, 2, 1,
    };
    
    LMBoard *board = [self boardWithRows:1 columns:4 values:values];
    board.numberOfShiftsPerSeed = 1;
    
    [board shiftRight];
    
    LMBoardItemLevel result[4] = {
        0, 1, 2, 1
    };
    
    [self assertBoard:board hasValues:result];
}

#pragma mark - Has Matches

- (void)testHashMatchesReturnsFalseForEmptyBoard
{
    LMBoard *board = [[LMBoard alloc] initWithRows:2 columns:2];
    
    XCTAssert(![board hasMatches], @"Board shouldn't have had matches");
}

- (void)testHasMatchesReturnsFalseForFilledBoard
{
    LMBoardItemLevel values[4] = {
        1, kEmpty,
        2, 3
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board hasMatches], @"Board shouldn't have had matches");
}

- (void)testHasMatchesReturnsTrueForVerticalMatches
{
    LMBoardItemLevel values[4] = {
        1, 2,
        1, 3
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert([board hasMatches], @"Board should've had matches");
}

- (void)testHasMatchesReturnsTrueForHorizontalMatches
{
    LMBoardItemLevel values[4] = {
        1, 1,
        2, 3
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert([board hasMatches], @"Board should've had matches");
}

#pragma mark - Is Full

- (void)testIsFullReturnsTrueWhenFull
{
    LMBoardItemLevel values[4] = {
        1, 4,
        2, 3
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert([board isFull], @"Board did not return that it was full.");
}

- (void)testIsFullReturnsFalseWhenCellIsEmpty
{
    LMBoardItemLevel values[4] = {
        1, kEmpty,
        2, 3
    };
    
    LMBoard *board = [self boardWithRows:2 columns:2 values:values];
    
    XCTAssert(![board isFull], @"Board returned that it was full.");
}

@end
