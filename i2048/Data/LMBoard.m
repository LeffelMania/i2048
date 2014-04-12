//
//  LMBoard.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoard.h"

#import "LMBoardItem.h"
#import "LMShiftResult.h"
#import "LMRandom.h"

@interface LMBoard ()

@property (nonatomic, assign) NSUInteger rowCount;
@property (nonatomic, assign) NSUInteger columnCount;

@property (nonatomic, assign) NSUInteger shiftsSinceLastSeed;

@property (nonatomic, strong) NSMutableArray *values;

@end

@implementation LMBoard

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols
{
    return [self initWithRows:rows columns:cols initialItemCount:0];
}

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols initialItemCount:(NSUInteger)count
{
    self = [super init];
    if (self)
    {
        NSAssert(rows > 0, @"Cannot create board with 0 rows");
        NSAssert(cols > 0, @"Cannot create board with 0 columns");
        
        self.rowCount = rows;
        self.columnCount = cols;
        
        self.values = [NSMutableArray array];
        
        [self createBoard];
        
        for (NSUInteger i = 0; i < count && i < [self count]; i++)
        {
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

- (LMShiftResult *)shiftUp
{
    return [self shiftBoardByRows:YES reverse:NO];
}

- (LMShiftResult *)shiftDown
{
    return [self shiftBoardByRows:YES reverse:YES];
}

- (LMShiftResult *)shiftLeft
{
    return [self shiftBoardByRows:NO reverse:NO];
}

- (LMShiftResult *)shiftRight
{
    return [self shiftBoardByRows:NO reverse:YES];
}

#pragma mark - Private Utility

- (void)createBoard
{
    [self.values removeAllObjects];
    
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        for (NSUInteger col = 0; col < self.columnCount; col++)
        {
            LMBoardItem *item = [[LMBoardItem alloc] initWithRow:row column:col];
            [self.values addObject:item];
        }
    }
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

- (LMShiftResult *)shiftBoardByRows:(BOOL)rows reverse:(BOOL)reverse
{
    NSMutableArray *moves = [NSMutableArray array];
    NSMutableArray *matches = [NSMutableArray array];
    
    NSUInteger count = rows ? self.columnCount : self.rowCount;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        NSIndexSet *itemSet = rows ? [self indexSetForColumn:i] : [self indexSetForRow:i];
        
        [matches addObjectsFromArray:[self consolidateIndexes:itemSet reverse:reverse]];
        [moves addObjectsFromArray:[self shiftIndexes:itemSet reverse:reverse]];
    }
    
    [self addSeedFromShift];
    
    return [[LMShiftResult alloc] initWithMatches:matches moves:moves];
}

- (NSArray *)consolidateIndexes:(NSIndexSet *)subset reverse:(BOOL)reverse
{
    NSMutableArray *matches = [NSMutableArray array];
    
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
                                        LMBoardEvent *event = [[LMBoardEvent alloc] initWithFromItem:item toItem:toMatch];
                                        [matches addObject:event];
                                        
                                        [toMatch advance];
                                        [item clear];
                                        
                                        toMatch = nil;
                                    }
                                }];
    
    return matches;
}

- (NSArray *)shiftIndexes:(NSIndexSet *)subset reverse:(BOOL)reverse
{
    NSMutableArray *moves = [NSMutableArray array];
    
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
                                        
                                        LMBoardEvent *event = [[LMBoardEvent alloc] initWithFromItem:item toItem:toFill];
                                        [moves addObject:event];
                                        
                                        toFill.level = item.level;
                                        [item clear];
                                        
                                        [fillQueue addObject:item];
                                    }
                                }];
    
    return moves;
}

- (NSUInteger)count
{
    return (self.rowCount * self.columnCount);
}

- (void)addSeedFromShift
{
    self.shiftsSinceLastSeed++;
    
    if (self.shiftsSinceLastSeed >= self.numberOfShiftsPerSeed)
    {
        self.shiftsSinceLastSeed = 0;
        [self insertNewItem];
    }
}

- (void)insertNewItem
{
    NSUInteger start = [LMRandom nextInteger:[self count]];
    
    NSUInteger index = start;
    do
    {
        NSUInteger row = index / self.columnCount;
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
