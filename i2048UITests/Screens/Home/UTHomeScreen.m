//
//  UTHomeScreen.m
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "UTHomeScreen.h"

#import "UTGameScreen.h"

@implementation UTHomeScreen

- (NSString *)idenitifyingLabel
{
    return @"i2048";
}

- (UTGameScreen *)goToGame
{
    [self tapViewWithAccessibilityLabel:@"Start Game"];
    
    return [UTGameScreen new];
}

- (void)setRows:(float)rows
{
    [self setValue:rows forSliderWithAccessibilityLabel:@"Row Slider"];
}

- (void)setColumns:(NSUInteger)columns
{
    [self setValue:columns forSliderWithAccessibilityLabel:@"Column Slider"];
}

- (void)setSeedCount:(NSUInteger)seeds
{
    [self setValue:seeds forSliderWithAccessibilityLabel:@"Seed Slider"];
}

@end
