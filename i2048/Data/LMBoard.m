//
//  LMBoard.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoard.h"

#import "LMBoardItem.h"

@interface LMBoard ()

@property (nonatomic, assign) NSUInteger rowCount;
@property (nonatomic, assign) NSUInteger columnCount;

@property (nonatomic, strong) NSMutableArray *values;

@end

@implementation LMBoard

- (instancetype)initWithSize:(NSUInteger)size
{
    return [self initWithRows:size columns:size values:nil];
}

- (instancetype)initWithSize:(NSUInteger)size values:(NSArray *)valueArray
{
    return [self initWithRows:size columns:size values:valueArray];
}

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols
{
    return [self initWithRows:rows columns:cols values:nil];
}

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols values:(NSArray *)valueArray
{
    self = [super init];
    if (self)
    {
        NSAssert(rows > 0, @"Cannot create board with 0 rows");
        NSAssert(cols > 0, @"Cannot create board with 0 columns");
        
        self.rowCount = rows;
        self.columnCount = cols;
        
        self.values = [self createBoard];
        
        if (valueArray)
        {
            NSAssert([valueArray count] == [self count], @"Expected %u items in provided values array, got %u", [self count], [valueArray count]);
            
            [valueArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
                
                LMBoardItem *item = self.values[idx];
                item.level = [obj integerValue];
            }];
        }
        else
        {
            [self insertNewItem];
            [self insertNewItem];
        }
    }
    return self;
}

#pragma mark - Public Interface

#pragma mark Aggregate Queries

- (LMBoardItem *)itemAtRow:(NSUInteger)row column:(NSUInteger)column
{
    if (row >= self.rowCount || column >= self.columnCount)
    {
        return nil;
    }
    
    NSUInteger index = (row * self.columnCount) + column;
    return self.values[index];
}

- (BOOL)isFull
{
    __block BOOL result = YES;
    
    [self.values enumerateObjectsUsingBlock:^(LMBoardItem *item, NSUInteger idx, BOOL *stop) {
        
        if ([item isEmpty])
        {
            result = NO;
            *stop = YES;
        }
    }];
    
    return result;
}

- (BOOL)hasMatches
{
    // Left/Right Matches
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        if ([self hasMatches:[self indexSetForRow:row]])
        {
            return YES;
        }
    }
    
    // Up/Down Matches
    for (NSUInteger col = 0; col < self.columnCount; col++)
    {
        if ([self hasMatches:[self indexSetForColumn:col]])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark Shift Queries

- (BOOL)canShiftUp
{
    for (NSUInteger col = 0; col < self.columnCount; col++)
    {
        if ([self canShiftIndexes:[self indexSetForColumn:col] reverse:NO])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftDown
{
    for (NSUInteger col = 0; col < self.columnCount; col++)
    {
        if ([self canShiftIndexes:[self indexSetForColumn:col] reverse:YES])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftLeft
{
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        if ([self canShiftIndexes:[self indexSetForRow:row] reverse:NO])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftRight
{
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        if ([self canShiftIndexes:[self indexSetForRow:row] reverse:YES])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark Shift Actions

- (void)shiftUp
{
    for (NSUInteger col = 0; col < self.columnCount; col++)
    {
        NSIndexSet *colSet = [self indexSetForColumn:col];
        
        [self consolidateIndexes:colSet reverse:NO];
        [self shiftIndexes:colSet reverse:NO];
    }
    
    [self insertNewItem];
}

- (void)shiftDown
{
    for (NSUInteger col = 0; col < self.columnCount; col++)
    {
        NSIndexSet *colSet = [self indexSetForColumn:col];
        
        [self consolidateIndexes:colSet reverse:YES];
        [self shiftIndexes:colSet reverse:YES];
    }
    
    [self insertNewItem];
}

- (void)shiftLeft
{
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        NSIndexSet *rowSet = [self indexSetForRow:row];
        
        [self consolidateIndexes:rowSet reverse:NO];
        [self shiftIndexes:rowSet reverse:NO];
    }
    
    [self insertNewItem];
}

- (void)shiftRight
{
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        NSIndexSet *rowSet = [self indexSetForRow:row];
        
        [self consolidateIndexes:rowSet reverse:YES];
        [self shiftIndexes:rowSet reverse:YES];
    }
    
    [self insertNewItem];
}

#pragma mark - Private Utility

- (NSMutableArray *)createBoard
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        for (NSUInteger col = 0; col < self.columnCount; col++)
        {
            [values addObject:[LMBoardItem new]];
        }
    }
    
    return values;
}

- (NSIndexSet *)indexSetForRow:(NSUInteger)row
{
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row * self.columnCount, self.columnCount)];
}

- (NSIndexSet *)indexSetForColumn:(NSUInteger)column
{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        [set addIndex:(row * self.columnCount) + column];
    }
    
    return set;
}

- (BOOL)hasMatches:(NSIndexSet *)subset
{
    __block BOOL result = NO;
    __block LMBoardItem *toMatch = nil;
    
    [self.values enumerateObjectsAtIndexes:subset
                                   options:0
                                usingBlock:^(LMBoardItem *item, NSUInteger idx, BOOL *stop) {
                                    
                                    if ([item isEmpty])
                                    {
                                        return;
                                    }
                                    
                                    if (!toMatch || ![item matches:toMatch])
                                    {
                                        toMatch = item;
                                    }
                                    else
                                    {
                                        result = YES;
                                        *stop = YES;
                                    }
                                }];
    
    return result;
}

- (BOOL)canShiftIndexes:(NSIndexSet *)subset reverse:(BOOL)reverse
{
    __block BOOL result = NO;
    __block BOOL wasEmpty = NO;
    
    [self.values enumerateObjectsAtIndexes:subset
                                   options:reverse ? NSEnumerationReverse : 0
                                usingBlock:^(LMBoardItem *item, NSUInteger idx, BOOL *stop) {
                                    
                                    BOOL isEmpty = [item isEmpty];
                                    if (wasEmpty && !isEmpty)
                                    {
                                        result = YES;
                                        *stop = YES;
                                    }
                                    
                                    wasEmpty = isEmpty;
                                }];
    
    return result;
}

- (void)consolidateIndexes:(NSIndexSet *)subset reverse:(BOOL)reverse
{
    __block LMBoardItem *toMatch = nil;
    
    [self.values enumerateObjectsAtIndexes:subset
                                   options:reverse ? NSEnumerationReverse : 0
                                usingBlock:^(LMBoardItem *item, NSUInteger idx, BOOL *stop) {
                                    
                                    if ([item isEmpty])
                                    {
                                        return;
                                    }
                                    
                                    if (!toMatch || ![item matches:toMatch])
                                    {
                                        toMatch = item;
                                    }
                                    else if ([item matches:toMatch])
                                    {
                                        [toMatch advance];
                                        [item clear];
                                        
                                        toMatch = nil;
                                    }
                                }];
}

- (void)shiftIndexes:(NSIndexSet *)subset reverse:(BOOL)reverse
{
    NSMutableArray *fillQueue = [NSMutableArray array];
    
    [self.values enumerateObjectsAtIndexes:subset
                                   options:reverse ? NSEnumerationReverse : 0
                                usingBlock:^(LMBoardItem *item, NSUInteger idx, BOOL *stop) {
                                    
                                    if ([item isEmpty])
                                    {
                                        [fillQueue addObject:item];
                                    }
                                    else if ([fillQueue count] > 0)
                                    {
                                        LMBoardItem *toFill = [fillQueue firstObject];
                                        [fillQueue removeObjectAtIndex:0];
                                        
                                        toFill.level = item.level;
                                        [item clear];
                                    }
                                }];
}

- (NSUInteger)count
{
    return (self.rowCount * self.columnCount);
}

- (void)insertNewItem
{
    if ([self isFull])
    {
        return;
    }
    
    NSUInteger start = arc4random() % [self count];
    
    NSUInteger index = start;
    do
    {
        NSUInteger row = index / self.rowCount;
        NSUInteger col = index % self.columnCount;
        
        LMBoardItem *item = [self itemAtRow:row column:col];
        if ([item isEmpty])
        {
            [item advance];
            return;
        }
        
        index = (index + 1) % [self count];
    }
    while (index != start);
}

- (NSString *)description
{
    NSMutableString *boardString = [NSMutableString string];
    
    __block NSUInteger col = 0;
    [self.values enumerateObjectsUsingBlock:^(LMBoardItem *item, NSUInteger idx, BOOL *stop) {
        
        [boardString appendFormat:@"%u ", item.level];
        col++;
        
        if (col % self.columnCount == 0)
        {
            [boardString appendString:@"\n"];
        }
    }];
    
    return [NSString stringWithFormat:@"LMBoard: @[\n%@]", boardString];
}

@end
