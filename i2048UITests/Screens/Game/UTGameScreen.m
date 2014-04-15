//
//  UTGameScreen.m
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "UTGameScreen.h"

@implementation UTGameScreen

- (NSString *)idenitifyingLabel
{
    return @"Quit";
}

- (void)goBack
{
    [self tapViewWithAccessibilityLabel:@"Quit"];
}

@end
