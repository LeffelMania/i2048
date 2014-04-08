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

@end
