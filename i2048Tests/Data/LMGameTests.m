//
//  LMGameTests.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "LMGame.h"
#import "LMBoard.h"
#import "LMBoardItem.h"
#import "LMShiftResult.h"

@interface LMGameTests : XCTestCase

@property (nonatomic, strong) LMGame *game;
@property (nonatomic, strong) id boardMock;

@end

@implementation LMGameTests

- (void)setUp
{
    [super setUp];
    
    self.boardMock = [OCMockObject niceMockForClass:[LMBoard class]];
    
    self.game = [[LMGame alloc] initWithBoard:self.boardMock];
}

- (void)testIsOverReturnsFalseIfBoardNotFull
{
    [[[self.boardMock stub] andReturnValue:@(NO)] hasMatches];
    [[[self.boardMock expect] andReturnValue:@(NO)] isFull];
    
    XCTAssert(![self.game isOver], @"Game shouldn't have been over with non-full board");
    
    [self.boardMock verify];
}

- (void)testIsOverReturnsFalseIfBoardHasMatches
{
    [[[self.boardMock expect] andReturnValue:@(YES)] hasMatches];
    [[[self.boardMock stub] andReturnValue:@(YES)] isFull];
    
    XCTAssert(![self.game isOver], @"Game shouldn't have been over with matches");
    
    [self.boardMock verify];
}

- (void)testIsOverReturnsTrueIfBoardIsFullAndNoMatchesExist
{
    [[[self.boardMock expect] andReturnValue:@(NO)] hasMatches];
    [[[self.boardMock expect] andReturnValue:@(YES)] isFull];
    
    XCTAssert([self.game isOver], @"Game shouldn't have been over with matches");
    
    [self.boardMock verify];
}

#pragma mark - Shift Up

- (void)testShiftUpReturnsNilIfCantShiftUp
{
    [[[self.boardMock expect] andReturnValue:@(NO)] canShiftUp];
    
    LMBoardItem *result = [self.game shiftUp];
    XCTAssert(result == nil, @"Shift should have returned nil");
    
    [self.boardMock verify];
}

- (void)testShiftUpReturnsAddedItem
{
    LMBoardItem *add = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:nil addition:add];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftUp];
    [[[self.boardMock expect] andReturn:result] shiftUp];
    
    LMBoardItem *item = [self.game shiftUp];
    
    XCTAssert(item == add, @"Shift didn't return added item");
    [self.boardMock verify];
}

- (void)testShiftUpUpdatesScore
{
    LMBoardItem *match = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:@[ match ] addition:nil];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftUp];
    [[[self.boardMock expect] andReturn:result] shiftUp];
    
    [self.game shiftUp];
    
    XCTAssert(self.game.score == match.value, @"Game score wasn't updated with match");
    [self.boardMock verify];
}

#pragma mark - Shift Down

- (void)testShiftDownReturnsNilIfCantShiftDown
{
    [[[self.boardMock expect] andReturnValue:@(NO)] canShiftDown];
    
    LMBoardItem *result = [self.game shiftDown];
    XCTAssert(result == nil, @"Shift should have returned nil");
    
    [self.boardMock verify];
}

- (void)testShiftDownReturnsAddedItem
{
    LMBoardItem *add = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:nil addition:add];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftDown];
    [[[self.boardMock expect] andReturn:result] shiftDown];
    
    LMBoardItem *item = [self.game shiftDown];
    
    XCTAssert(item == add, @"Shift didn't return added item");
    [self.boardMock verify];
}

- (void)testShiftDownUpdatesScore
{
    LMBoardItem *match = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:@[ match ] addition:nil];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftDown];
    [[[self.boardMock expect] andReturn:result] shiftDown];
    
    [self.game shiftDown];
    
    XCTAssert(self.game.score == match.value, @"Game score wasn't updated with match");
    [self.boardMock verify];
}

#pragma mark - Shift Left

- (void)testShiftLeftReturnsNilIfCantShiftLeft
{
    [[[self.boardMock expect] andReturnValue:@(NO)] canShiftLeft];
    
    LMBoardItem *result = [self.game shiftLeft];
    XCTAssert(result == nil, @"Shift should have returned nil");
    
    [self.boardMock verify];
}

- (void)testShiftLeftReturnsAddedItem
{
    LMBoardItem *add = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:nil addition:add];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftLeft];
    [[[self.boardMock expect] andReturn:result] shiftLeft];
    
    LMBoardItem *item = [self.game shiftLeft];
    
    XCTAssert(item == add, @"Shift didn't return added item");
    [self.boardMock verify];
}

- (void)testShiftLeftUpdatesScore
{
    LMBoardItem *match = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:@[ match ] addition:nil];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftLeft];
    [[[self.boardMock expect] andReturn:result] shiftLeft];
    
    [self.game shiftLeft];
    
    XCTAssert(self.game.score == match.value, @"Game score wasn't updated with match");
    [self.boardMock verify];
}

#pragma mark - Shift Right

- (void)testShiftRightReturnsNilIfCantShiftRight
{
    [[[self.boardMock expect] andReturnValue:@(NO)] canShiftRight];
    
    LMBoardItem *result = [self.game shiftRight];
    XCTAssert(result == nil, @"Shift should have returned nil");
    
    [self.boardMock verify];
}

- (void)testShiftRightReturnsAddedItem
{
    LMBoardItem *add = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:nil addition:add];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftRight];
    [[[self.boardMock expect] andReturn:result] shiftRight];
    
    LMBoardItem *item = [self.game shiftRight];
    
    XCTAssert(item == add, @"Shift didn't return added item");
    [self.boardMock verify];
}

- (void)testShiftRightUpdatesScore
{
    LMBoardItem *match = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    LMShiftResult *result = [[LMShiftResult alloc] initWithMatches:@[ match ] addition:nil];
    
    [[[self.boardMock expect] andReturnValue:@(YES)] canShiftRight];
    [[[self.boardMock expect] andReturn:result] shiftRight];
    
    [self.game shiftRight];
    
    XCTAssert(self.game.score == match.value, @"Game score wasn't updated with match");
    [self.boardMock verify];
}

@end
