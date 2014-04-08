//
//  LMBoardItemTests.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LMBoardItem.h"

@interface LMBoardItemTests : XCTestCase

@property (nonatomic, strong) LMBoardItem *item;

@end

@implementation LMBoardItemTests

- (void)setUp
{
    [super setUp];
    
    self.item = [LMBoardItem new];
}

- (void)testDescriptionDoesntCrash
{
    XCTAssertNoThrow([self.item description], @"");
}

- (void)testInitializationIsEmpty
{
    XCTAssert([self.item isEmpty], @"Freshly initialized item was not empty");
}

- (void)testDoesNotMatchNil
{
    self.item.level = 2;
    XCTAssert(![self.item matches:nil], @"Item matched nil");
}

- (void)testDoesNotMatchIfEmpty
{
    XCTAssert(![self.item matches:self.item], @"Empty item matched itself");
}

- (void)testMatchesOnLevel
{
    self.item.level = 2;
    
    LMBoardItem *otherItem = [LMBoardItem new];
    otherItem.level = self.item.level;
    
    XCTAssert([self.item matches:otherItem], @"Item didn't match item with same level");
}

- (void)testClearMakesItemEmpty
{
    self.item.level = 2;
    [self.item clear];
    
    XCTAssert([self.item isEmpty], @"Item was not empty after clear");
}

- (void)testAdvance
{
    NSUInteger level = [self.item advance];
    XCTAssert(level == 1, @"Level should have been 1 after advance");
    
    level = [self.item advance];
    XCTAssert(level == 2, @"Level should have been 2 after advance");
}

@end
