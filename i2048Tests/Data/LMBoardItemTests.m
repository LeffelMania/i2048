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

- (void)testInitializedItemIsAlive
{
    XCTAssert([self.item isAlive], @"Item wasn't alive after initialization");
}

- (void)testDoesNotMatchNil
{
    XCTAssert(![self.item matches:nil], @"Item matched nil");
}

- (void)testMatchesReturnsTrueForEqualLevels
{
    LMBoardItem *otherItem = [[LMBoardItem alloc] initWithRow:0 column:0 level:self.item.level];
    
    XCTAssert([self.item matches:otherItem], @"Item didn't match item with same level");
}

- (void)testMatchesReturnFalseForDifferentLevels
{
    LMBoardItem *otherItem = [[LMBoardItem alloc] initWithRow:0 column:0 level:self.item.level + 1];
    
    XCTAssert(![self.item matches:otherItem], @"Item matched item with different level");
}

- (void)testMergeIntoParentKillsObject
{
    LMBoardItem *otherItem = [[LMBoardItem alloc] initWithRow:0 column:0];
    [self.item mergeIntoParent:otherItem];
    
    XCTAssert(![self.item isAlive], @"Item was alive after merge into parent");
}

- (void)testMergeIntoParentIncreasesParentLevel
{
    LMBoardItem *otherItem = [[LMBoardItem alloc] initWithRow:0 column:0 level:1];
    [self.item mergeIntoParent:otherItem];
    
    XCTAssert(otherItem.level == 2, @"Parent level did not increase after merge");
}

@end
