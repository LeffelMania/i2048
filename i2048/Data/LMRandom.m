//
//  LMRandom.m
//  i2048
//
//  Created by Alex Leffelman on 4/11/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMRandom.h"

@implementation LMRandom

+ (instancetype)instance
{
    static LMRandom *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LMRandom alloc] init];
    });
    
    return instance;
}

- (NSUInteger)nextInteger:(NSUInteger)upperBoundExclusive
{
    return arc4random_uniform((unsigned int)upperBoundExclusive);
}

- (BOOL)nextBoolWithChanceOfTrue:(CGFloat)weight
{
    NSUInteger val = [self nextInteger:100];
    NSUInteger trueCutoff = 100*weight;
    
    return val <= trueCutoff;
}

@end
