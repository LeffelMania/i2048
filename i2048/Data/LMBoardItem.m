//
//  LMBoardValue.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoardItem.h"

@interface LMBoardItem ()

@property (nonatomic, strong) LMBoardItem *parent;
@property (nonatomic, assign) BOOL isAlive;

@property (nonatomic, strong) NSMutableArray *children;

@end

@implementation LMBoardItem

- (instancetype)init
{
    return [self initWithRow:0 column:0];
}

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column
{
    return [self initWithRow:row column:column level:0];
}

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column level:(NSUInteger)level
{
    self = [super init];
    if (self)
    {
        self.row = row;
        self.column = column;
        
        self.children = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < level; i++)
        {
            LMBoardItem *child = [[LMBoardItem alloc] initWithRow:row column:column];
            [self.children addObject:child];
        }
        
        self.isAlive = YES;
    }
    return self;
}

#pragma mark - Public Interface

- (LMBoardItemLevel)level
{
    return [self.children count];
}

- (void)mergeIntoParent:(LMBoardItem *)parent
{
    [parent.children addObject:self];
    
    self.parent = parent;
    self.isAlive = NO;
}

- (BOOL)matches:(LMBoardItem *)otherItem
{
    if (!otherItem)
    {
        return NO;
    }
    
    return self.level == otherItem.level;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"LMBoardItem at (r%u, c%u): %@", self.row, self.column, @(self.level)];
}

@end
