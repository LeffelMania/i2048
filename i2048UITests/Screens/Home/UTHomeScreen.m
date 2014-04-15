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

- (void)setRows:(NSUInteger)rows
{
    [self setValue:rows forSlider:@"Row Slider"];
}

- (void)setColumns:(NSUInteger)columns
{
    [self setValue:columns forSlider:@"Column Slider"];
}

- (void)setSeedCount:(NSUInteger)seeds
{
    [self setValue:seeds forSlider:@"Seed Slider"];
}

#pragma mark - Private Utility

- (void)setValue:(NSUInteger)val forSlider:(NSString *)slider
{
    [self setValue:val forSliderWithAccessibilityLabel:slider];
}

@end
