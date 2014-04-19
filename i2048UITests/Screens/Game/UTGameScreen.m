//
//  UTGameScreen.m
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "UTGameScreen.h"

@implementation UTGameScreen

static NSString *const kBoardLabel = @"Game Board";

- (NSString *)idenitifyingLabel
{
    return kBoardLabel;
}

- (void)goBack
{
    [self tapViewWithAccessibilityLabel:@"Quit"];
    [self waitForTimeInterval:UTWaitInterval];
}

- (void)shiftUp
{
    [self shiftInDirection:KIFSwipeDirectionUp];
}

- (void)shiftDown
{
    [self shiftInDirection:KIFSwipeDirectionDown];
}

- (void)shiftLeft
{
    [self shiftInDirection:KIFSwipeDirectionLeft];
}

- (void)shiftRight
{
    [self shiftInDirection:KIFSwipeDirectionRight];
}

- (void)shiftInDirection:(KIFSwipeDirection)direction
{
    [self swipeViewWithAccessibilityLabel:kBoardLabel inDirection:direction];
}

- (void)dismissGameOverAlert
{
    [self tapViewWithAccessibilityLabel:@"Neat-O"];
}

@end
