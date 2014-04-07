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

static NSUInteger const kBoardSize = 3;

@interface LMBoardTests : XCTestCase

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) LMBoard *board;

@end

@implementation LMBoardTests

- (void)setUp
{
    [super setUp];
    
    self.values = @[
                    @(1), @(2), @(3),
                    @(4), @(5), @(6),
                    @(7), @(8), @(9),
                    ];
    
    self.board = [[LMBoard alloc] initWithSize:kBoardSize values:self.values];
}

- (void)testDescriptionDoesntCrash
{
    NSLog(@"%@", self.board);
}

- (void)testEdgeCases
{
    [self.board iterateBoardWithBlock:nil];
    [self.board iterateRow:1000 withBlock:nil];
    [self.board iterateColumn:1000 withBlock:nil];
    
    LMBoardItem *item = [self.board itemAtRow:0 column:1000];
    XCTAssert(item == nil, @"Out-of-bounds board item wasn't nil");
    
    item = [self.board itemAtRow:1000 column:0];
    XCTAssert(item == nil, @"Out-of-bounds board item wasn't nil");
}

- (void)testIndexItemFetch
{
    for (NSUInteger row = 0; row < kBoardSize; row++)
    {
        for (NSUInteger col = 0; col < kBoardSize; col++)
        {
            NSUInteger index = (row * kBoardSize) + col;
            
            LMBoardItem *item = [self.board itemAtRow:row column:col];
            XCTAssert(item.level == [self.values[index] unsignedIntegerValue], @"Board iteration failed at index %u; expected %@, got %u", index, self.values[index], item.level);
        }
    }
}

- (void)testFullIteration
{
    __block NSUInteger index = 0;
    [self.board iterateBoardWithBlock:^BOOL(LMBoardItem *item) {
        
        XCTAssert(item.level == [self.values[index] unsignedIntegerValue], @"Board iteration failed at index %u; expected %@, got %u", index, self.values[index], item.level);
        index++;
        
        return NO;
    }];
    
    XCTAssert(index == (kBoardSize * kBoardSize), @"Board iteration expected %u items, iterated over %u", kBoardSize, index);
}

- (void)testRowIteration
{
    __block NSUInteger index = 0;
    [self.board iterateRow:0 withBlock:^BOOL(LMBoardItem *item) {
        
        XCTAssert(item.level == [self.values[index] unsignedIntegerValue], @"Board iteration failed at index %u; expected %@, got %u", index, self.values[index], item.level);
        index++;
        
        return NO;
    }];
    
    XCTAssert(index == kBoardSize, @"Board row iteration expected %u items, iterated over %u", kBoardSize, index);
}

- (void)testColumnIteration
{
    NSUInteger column = 1;
    __block NSUInteger index = column;
    __block NSUInteger count = 0;
    
    [self.board iterateColumn:column withBlock:^BOOL(LMBoardItem *item) {
        
        XCTAssert(item.level == [self.values[index] unsignedIntegerValue], @"Board iteration failed at index %u; expected %@, got %u", index, self.values[index], item.level);
        index += kBoardSize;
        count++;
        
        return NO;
    }];
    
    XCTAssert(count == kBoardSize, @"Board row iteration expected %u items, iterated over %u", kBoardSize, count);
}

- (void)testIsFull
{
    XCTAssert([self.board isFull], @"Board did not return that it was full.");
    
    LMBoardItem *item = [self.board itemAtRow:0 column:0];
    [item clear];
    
    XCTAssert(![self.board isFull], @"Board returned that it was full.");
}

- (void)testIsRowFull
{
    XCTAssert([self.board isRowFull:0], @"Board did not return that row was full.");
    
    LMBoardItem *item = [self.board itemAtRow:0 column:0];
    [item clear];
    
    XCTAssert(![self.board isRowFull:0], @"Board returned that row was full.");
}

- (void)testIsColumnFull
{
    XCTAssert([self.board isColumnFull:0], @"Board did not return that row was full.");
    
    LMBoardItem *item = [self.board itemAtRow:0 column:0];
    [item clear];
    
    XCTAssert(![self.board isColumnFull:0], @"Board returned that row was full.");
}

@end
