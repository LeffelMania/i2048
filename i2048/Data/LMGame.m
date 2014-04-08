//
//  LMGame.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMGame.h"

#import "LMBoard.h"

@interface LMGame ()

@property (nonatomic, strong) LMBoard *board;

@end

@implementation LMGame

- (instancetype)initWithBoard:(LMBoard *)board;
{
    self = [super init];
    if (self)
    {
        self.board = board;
    }
    return self;
}

#pragma mark - Public Interface

- (BOOL)isOver
{
    return [self.board isFull] && ![self.board hasMatches];
}

#pragma mark - Private Utility

@end
