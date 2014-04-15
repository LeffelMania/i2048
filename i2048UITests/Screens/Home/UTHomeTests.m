//
//  UTHomeTests.m
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <KIF/KIFTestCase.h>

#import "UTHomeScreen.h"
#import "UTGameScreen.h"

@interface UTHomeTests : KIFTestCase

@property (nonatomic, strong) UTHomeScreen *homeScreen;

@end

@implementation UTHomeTests

- (void)beforeEach
{
    self.homeScreen = [UTHomeScreen new];
    [self.homeScreen assertVisible];
}

- (void)testGoToGame
{
    UTGameScreen *gameScreen = [self.homeScreen goToGame];
    
    [gameScreen assertVisible];
    
    [gameScreen goBack];
    
    [self.homeScreen assertVisible];
}

- (void)testRowSliderDisplaysRowCount
{
    [self.homeScreen setRows:5];
    [tester waitForViewWithAccessibilityLabel:@"5"];
}

- (void)testColumnSliderDisplaysColumnCount
{
    [self.homeScreen setColumns:3];
    [tester waitForViewWithAccessibilityLabel:@"3"];
}

- (void)testSeedSliderDisplaysSeedCount
{
    [self.homeScreen setSeedCount:6];
    [tester waitForViewWithAccessibilityLabel:@"6"];
}

@end
