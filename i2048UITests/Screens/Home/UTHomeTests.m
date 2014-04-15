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
}

- (void)testGoToGame
{
    UTGameScreen *gameScreen = [self.homeScreen goToGame];
    
    [gameScreen assertVisible];
    
    [gameScreen goBack];
    
    [self.homeScreen assertVisible];
}

- (void)testRowSlidersDisplaysRowCount
{
    [self.homeScreen setRows:5];
    [tester waitForViewWithAccessibilityLabel:@"5"];
}

@end
