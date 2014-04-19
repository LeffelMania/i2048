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
#import "LMBoardItem.h"
#import "LMBoardItemView.h"

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
    
    self.randomMock = [OCMockObject partialMockForObject:[LMRandom instance]];
    [[[[self.randomMock stub] ignoringNonObjectArgs] andReturnValue:OCMOCK_VALUE(YES)] nextBoolWithChanceOfTrue:0.9f];
}

- (void)afterEach
{
    [self.gameScreen goBack];
}

- (void)stubRandomInt:(NSUInteger)val
{
    [[[[self.randomMock stub] ignoringNonObjectArgs] andReturnValue:OCMOCK_VALUE(val)] nextInteger:0];
}

- (void)goToGameWithRows:(NSUInteger)rows columns:(NSUInteger)columns seeds:(NSUInteger)seeds
{
    [self.homeScreen setRows:rows];
    [self.homeScreen setColumns:columns];
    [self.homeScreen setSeedCount:seeds];
    [self.homeScreen goToGame];
}

- (void)expectViewAtRow:(NSUInteger)row column:(NSUInteger)col withLevel:(LMBoardItemLevel)level
{
    [tester waitForViewWithAccessibilityLabel:@"Board Tile"
                                        value:[LMBoardItemView accessibilityValueForRow:row column:col level:level]
                                       traits:UIAccessibilityTraitNone];
}

#pragma mark - Shift Left

- (void)testShiftLeftMovesViews
{
    [self stubRandomInt:1];
    
    [self goToGameWithRows:2 columns:2 seeds:2];
    
    [self expectViewAtRow:0 column:1 withLevel:0];
    [self expectViewAtRow:1 column:0 withLevel:0];
    
    [self.gameScreen shiftLeft];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
    [self expectViewAtRow:1 column:0 withLevel:0];
}

- (void)testShiftLeftConsolidatesItemViews
{
    [self stubRandomInt:0];
    
    [self goToGameWithRows:1 columns:3 seeds:2];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
    [self expectViewAtRow:0 column:1 withLevel:0];
    
    [self.gameScreen shiftLeft];
    
    [self expectViewAtRow:0 column:0 withLevel:1];
}

- (void)testShiftLeftAddsNewItemView
{
    [self stubRandomInt:1];
    
    [self goToGameWithRows:1 columns:2 seeds:1];
    
    [self.gameScreen shiftLeft];
    
    [self expectViewAtRow:0 column:1 withLevel:0];
}

#pragma mark - Shift Right

- (void)testShiftRightMovesViews
{
    [self stubRandomInt:1];
    
    [self goToGameWithRows:2 columns:2 seeds:2];
    
    [self expectViewAtRow:0 column:1 withLevel:0];
    [self expectViewAtRow:1 column:0 withLevel:0];
    
    [self.gameScreen shiftRight];
    
    [self expectViewAtRow:0 column:1 withLevel:0];
    [self expectViewAtRow:1 column:1 withLevel:0];
}

- (void)testShiftRightConsolidatesItemViews
{
    [self stubRandomInt:0];
    
    [self goToGameWithRows:1 columns:3 seeds:2];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
    [self expectViewAtRow:0 column:1 withLevel:0];
    
    [self.gameScreen shiftRight];
    
    [self expectViewAtRow:0 column:2 withLevel:1];
}

- (void)testShiftRightAddsNewItemView
{
    [self stubRandomInt:0];
    
    [self goToGameWithRows:1 columns:2 seeds:1];
    
    [self.gameScreen shiftRight];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
}

#pragma mark - Shift Up

- (void)testShiftUpMovesViews
{
    [self stubRandomInt:1];
    
    [self goToGameWithRows:2 columns:2 seeds:2];
    
    [self expectViewAtRow:0 column:1 withLevel:0];
    [self expectViewAtRow:1 column:0 withLevel:0];
    
    [self.gameScreen shiftUp];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
    [self expectViewAtRow:0 column:1 withLevel:0];
}

- (void)testShiftUpConsolidatesItemViews
{
    [self stubRandomInt:0];
    
    [self goToGameWithRows:3 columns:1 seeds:2];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
    [self expectViewAtRow:1 column:0 withLevel:0];
    
    [self.gameScreen shiftUp];
    
    [self expectViewAtRow:0 column:0 withLevel:1];
}

- (void)testShiftUpAddsNewItemView
{
    [self stubRandomInt:1];
    
    [self goToGameWithRows:2 columns:1 seeds:1];
    
    [self.gameScreen shiftUp];
    
    [self expectViewAtRow:1 column:0 withLevel:0];
}

#pragma mark - Shift Down

- (void)testShiftDownMovesViews
{
    [self stubRandomInt:1];
    
    [self goToGameWithRows:2 columns:2 seeds:2];
    
    [self expectViewAtRow:0 column:1 withLevel:0];
    [self expectViewAtRow:1 column:0 withLevel:0];
    
    [self.gameScreen shiftDown];
    
    [self expectViewAtRow:1 column:0 withLevel:0];
    [self expectViewAtRow:1 column:1 withLevel:0];
}

- (void)testShiftDownConsolidatesItemViews
{
    [self stubRandomInt:0];
    
    [self goToGameWithRows:3 columns:1 seeds:2];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
    [self expectViewAtRow:1 column:0 withLevel:0];
    
    [self.gameScreen shiftDown];
    
    [self expectViewAtRow:2 column:0 withLevel:1];
}

- (void)testShiftDownAddsNewItemView
{
    [self stubRandomInt:0];
    
    [self goToGameWithRows:2 columns:1 seeds:1];
    
    [self.gameScreen shiftDown];
    
    [self expectViewAtRow:0 column:0 withLevel:0];
}

#pragma mark - Game Over

- (void)testGameOverDialogDisplaysWhenNoMatchesLeft
{
    [self stubRandomInt:0];
    
    [self goToGameWithRows:1 columns:2 seeds:2];
    
    [self.gameScreen shiftRight];
    
    [self.gameScreen dismissGameOverAlert];
    
    [self.homeScreen assertVisible];
    
    // So that afterEach still succeeds
    [self goToGameWithRows:1 columns:2 seeds:2];
}

@end
