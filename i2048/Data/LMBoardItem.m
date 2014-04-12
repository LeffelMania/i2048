//
//  LMBoardValue.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoardItem.h"

LMBoardItemLevel const LMBoardItemEmpty = 0;

@interface LMBoardItem ()

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;

@end

@implementation LMBoardItem

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column
{
    self = [super init];
    if (self)
    {
        self.row = row;
        self.column = column;
        
        [self clear];
    }
    return self;
}

#pragma mark - Public Interface

- (BOOL)isEmpty
{
    return self.level == LMBoardItemEmpty;
}

- (void)clear
{
    self.level = LMBoardItemEmpty;
}

- (LMBoardItemLevel)advance
{
    if (self.level == LMBoardItemEmpty)
    {
        self.level = 1;
    }
    else
    {
        self.level++;
    }
    
    return self.level;
}

- (BOOL)matches:(LMBoardItem *)otherItem
{
    if (!otherItem)
    {
        return NO;
    }
    
    if ([self isEmpty])
    {
        return NO;
    }
    
    return self.level == otherItem.level;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"LMBoardItem at (r%u, c%u): %@", self.row, self.column, [self isEmpty] ? @"Empty" : @(self.level)];
}

@end
