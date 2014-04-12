//
//  LMRandom.m
//  i2048
//
//  Created by Alex Leffelman on 4/11/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMRandom.h"

@implementation LMRandom

+ (NSUInteger)nextInteger:(NSUInteger)upperBoundExclusive
{
    return arc4random_uniform(upperBoundExclusive);
}

@end
