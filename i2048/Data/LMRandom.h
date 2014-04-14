//
//  LMRandom.h
//  i2048
//
//  Created by Alex Leffelman on 4/11/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMRandom : NSObject

+ (NSUInteger)nextInteger:(NSUInteger)upperBoundExclusive;
+ (BOOL)nextBoolWithChanceOfTrue:(CGFloat)weight;

@end
