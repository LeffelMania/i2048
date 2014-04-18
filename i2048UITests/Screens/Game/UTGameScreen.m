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
}

- (void)shiftUp
{
    [self swipeViewWithAccessibilityLabel:kBoardLabel inDirection:KIFSwipeDirectionUp];
}

- (void)shiftDown
{
    [self swipeViewWithAccessibilityLabel:kBoardLabel inDirection:KIFSwipeDirectionDown];
}

- (void)shiftLeft
{
    [self swipeViewWithAccessibilityLabel:kBoardLabel inDirection:KIFSwipeDirectionLeft];
}

- (void)shiftRight
{
    [self swipeViewWithAccessibilityLabel:kBoardLabel inDirection:KIFSwipeDirectionRight];
}

@end
