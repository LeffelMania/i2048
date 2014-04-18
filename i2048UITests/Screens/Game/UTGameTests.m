//
//  UTGameTests.m
//  i2048
//
//  Created by Alex Leffelman on 4/15/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <KIF/KIFTestCase.h>
#import <OCMock/OCMock.h>

#import "UTHomeScreen.h"
#import "UTGameScreen.h"

#import "LMRandom.h"

@interface UTGameTests : KIFTestCase

@property (nonatomic, strong) UTHomeScreen *homeScreen;
@property (nonatomic, strong) UTGameScreen *gameScreen;
@property (nonatomic, strong) id randomMock;

@end

@implementation UTGameTests

- (void)beforeEach
{
    self.homeScreen = [UTHomeScreen new];
    self.gameScreen = [UTGameScreen new];
    self.randomMock = [OCMockObject mockForClass:[LMRandom class]];
}

- (void)goToGameWithRows:(NSUInteger)rows columns:(NSUInteger)columns seeds:(NSUInteger)seeds
{
    [self.homeScreen setRows:rows];
    [self.homeScreen setColumns:columns];
    [self.homeScreen setSeedCount:seeds];
    [self.homeScreen goToGame];
}

- (void)testShiftLeftMovesViews
{
    [[[[self.randomMock expect] ignoringNonObjectArgs] andReturnValue:OCMOCK_VALUE(0u)] nextInteger:4];
    [[[[self.randomMock expect] ignoringNonObjectArgs] andReturnValue:OCMOCK_VALUE(YES)] nextBoolWithChanceOfTrue:0.9f];
    
    [self goToGameWithRows:2 columns:2 seeds:2];
    
    [tester waitForTimeInterval:1];
    [self.gameScreen shiftLeft];
    [tester waitForTimeInterval:1];
    
    [self.gameScreen goBack];
}

@end
