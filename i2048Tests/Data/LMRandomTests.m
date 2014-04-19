//
//  LMRandomTests.m
//  i2048
//
//  Created by Alex Leffelman on 4/18/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LMRandom.h"
#import <OCMock/OCMock.h>

@interface LMRandomTests : XCTestCase

@property (nonatomic, strong) id randomMock;

@end

@implementation LMRandomTests

- (void)setUp
{
    [super setUp];
    
    self.randomMock = [OCMockObject partialMockForObject:[LMRandom instance]];
}

- (void)testUpperBoundIsNeverExceeded
{
    NSUInteger upperBound = 10;
    
    BOOL exceeded = NO;
    for (NSUInteger i = 0; i < (upperBound * 10); i++)
    {
        NSUInteger result = [[LMRandom instance] nextInteger:upperBound];
        if (result >= upperBound)
        {
            NSLog(@"result %u meets or exceeds upper bound %u", result, upperBound);
            exceeded = YES;
            break;
        }
    }
    
    XCTAssert(!exceeded, @"Upper bound %u was exceeded", upperBound);
}

- (void)expectNextInt:(NSUInteger)result
{
    [[[[self.randomMock expect] ignoringNonObjectArgs] andReturnValue:OCMOCK_VALUE(result)] nextInteger:0];
}

- (void)testNextBoolReturnsNoIfNextIntExceedsTrueThreshold
{
    [self expectNextInt:60];
    
    BOOL result = [[LMRandom instance] nextBoolWithChanceOfTrue:.4];
    [self.randomMock verify];
    
    XCTAssert(!result, @"Expected next bool to be false");
}

- (void)testNextBoolReturnsYesIfNextIntIsLessThanTrueThreshold
{
    [self expectNextInt:60];
    
    BOOL result = [[LMRandom instance] nextBoolWithChanceOfTrue:.7];
    [self.randomMock verify];
    
    XCTAssert(result, @"Expected next bool to be true");
}

- (void)testNextBoolReturnsYesIfNextIntEqualsTrueThreshold
{
    [self expectNextInt:60];
    
    BOOL result = [[LMRandom instance] nextBoolWithChanceOfTrue:.6];
    [self.randomMock verify];
    
    XCTAssert(result, @"Expected next bool to be true");
}

@end
