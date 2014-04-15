//
//  LMBoard.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoard.h"

#import "LMBoardItem.h"
#import "LMRandom.h"
#import "LMShiftOperation.h"
#import "LMShiftResult.h"

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
    if (self.values[index] == LMBoardItemEmpty)
    {
        return nil;
    }

    return self.values[index];
}

- (BOOL)isFull
{
    __block BOOL result = YES;
    
    [self.values enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        
        if (item == LMBoardItemEmpty)
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
    return [self canPerformShift:[LMShiftOperation shiftUp]];
}

- (BOOL)canShiftDown
{
    return [self canPerformShift:[LMShiftOperation shiftDown]];
}

- (BOOL)canShiftLeft
{
    return [self canPerformShift:[LMShiftOperation shiftLeft]];
}

- (BOOL)canShiftRight
{
    return [self canPerformShift:[LMShiftOperation shiftRight]];
}

#pragma mark Shift Actions

- (LMShiftResult *)shiftUp
{
    return [self performShiftOperation:[LMShiftOperation shiftUp]];
}

- (LMShiftResult *)shiftDown
{
    return [self performShiftOperation:[LMShiftOperation shiftDown]];
}

- (LMShiftResult *)shiftLeft
{
    return [self performShiftOperation:[LMShiftOperation shiftLeft]];
}

- (LMShiftResult *)shiftRight
{
    return [self performShiftOperation:[LMShiftOperation shiftRight]];
}

#pragma mark - Private Utility

- (void)createBoard
{
    [self.values removeAllObjects];
    
    for (NSUInteger row = 0; row < self.rowCount; row++)
    {
        for (NSUInteger col = 0; col < self.columnCount; col++)
        {
            [self.values addObject:LMBoardItemEmpty];
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
    
    [subset enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        if (self.values[idx] == LMBoardItemEmpty)
        {
            return;
        }
        
        LMBoardItem *item = self.values[idx];
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

- (BOOL)canPerformShift:(LMShiftOperation *)shift
{
    NSUInteger count = shift.useColumnIndexes ? self.columnCount : self.rowCount;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        NSIndexSet *subset = shift.useColumnIndexes ? [self indexSetForColumn:i] : [self indexSetForRow:i];
        
        if ([self canShiftIndexes:subset reverse:shift.reverseIteration])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftIndexes:(NSIndexSet *)subset reverse:(BOOL)reverse
{
    if ([self hasMatches:subset])
    {
        return YES;
    }
    
    __block BOOL result = NO;
    __block BOOL wasEmpty = NO;
    
    [subset enumerateIndexesWithOptions:reverse ? NSEnumerationReverse : 0
                             usingBlock:^(NSUInteger idx, BOOL *stop) {
                                 
                                 BOOL isEmpty = self.values[idx] == LMBoardItemEmpty;
                                 if (wasEmpty && !isEmpty)
                                 {
                                     result = YES;
                                     *stop = YES;
                                 }
                                 
                                 wasEmpty = isEmpty;
                             }];
    
    return result;
}

- (LMShiftResult *)performShiftOperation:(LMShiftOperation *)shift
{
    NSMutableArray *allMatches = [NSMutableArray array];
    
    NSUInteger count = shift.useColumnIndexes ? self.columnCount : self.rowCount;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        NSIndexSet *itemSet = shift.useColumnIndexes ? [self indexSetForColumn:i] : [self indexSetForRow:i];
        
        NSArray *matches = [self consolidateIndexes:itemSet reverse:shift.reverseIteration];
        [allMatches addObjectsFromArray:matches];
    }
    
    LMBoardItem *newItem = [self addSeedFromShift];
    
    return [[LMShiftResult alloc] initWithMatches:allMatches addition:newItem];
}

- (NSArray *)consolidateIndexes:(NSIndexSet *)subset reverse:(BOOL)reverse
{
    NSMutableArray *matchedItems = [NSMutableArray array];
    
    __block LMBoardItem *toMatch = nil;
    NSMutableArray *fillQueue = [NSMutableArray array];
    
    [subset enumerateIndexesWithOptions:reverse ? NSEnumerationReverse : 0
                             usingBlock:^(NSUInteger idx, BOOL *stop) {
                                 
                                 if (self.values[idx] == LMBoardItemEmpty)
                                 {
                                     [fillQueue addObject:@(idx)];
                                     return;
                                 }
                                 
                                 LMBoardItem *item = self.values[idx];
                                 
                                 if (toMatch && [item matches:toMatch])
                                 {
                                     [item mergeIntoParent:toMatch];
                                     self.values[idx] = LMBoardItemEmpty;
                                     
                                     [matchedItems addObject:toMatch];
                                     
                                     [fillQueue addObject:@(idx)];
                                     
                                     toMatch = nil;
                                     return;
                                 }
                                 
                                 toMatch = item;
                                 
                                 if ([fillQueue count] > 0)
                                 {
                                     NSUInteger fillIndex = [[fillQueue firstObject] unsignedIntegerValue];
                                     [fillQueue removeObjectAtIndex:0];
                                     
                                     [self moveItem:item fromIndex:idx toIndex:fillIndex];
                                     
                                     [fillQueue addObject:@(idx)];
                                 }
                             }];
    
    return matchedItems;
}

- (void)moveItem:(LMBoardItem *)item fromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    NSAssert(self.values[to] == LMBoardItemEmpty, @"Shouldn't be moving an item into an index that is not null!");
    
    item.row = to / self.columnCount;
    item.column = to % self.columnCount;
    
    self.values[to] = item;
    self.values[from] = LMBoardItemEmpty;
}

- (NSUInteger)count
{
    return (self.rowCount * self.columnCount);
}

- (LMBoardItem *)addSeedFromShift
{
    self.shiftsSinceLastSeed++;
    
    if (self.shiftsSinceLastSeed >= self.numberOfShiftsPerSeed)
    {
        self.shiftsSinceLastSeed = 0;
        return [self insertNewItem];
    }
    
    return nil;
}

- (LMBoardItem *)insertNewItem
{
    NSUInteger start = [LMRandom nextInteger:[self count]];
    
    NSUInteger index = start;
    do
    {
        NSUInteger row = index / self.columnCount;
        NSUInteger col = index % self.columnCount;
        
        LMBoardItem *item = [self itemAtRow:row column:col];
        if (!item)
        {
            LMBoardItemLevel level = [LMRandom nextBoolWithChanceOfTrue:.9f] ? 0 : 1;
            item = [[LMBoardItem alloc] initWithRow:row column:col level:level];
            self.values[index] = item;
            
            return item;
        }
        
        index = (index + 1) % [self count];
    }
    while (index != start);
    
    return nil;
}

// Purely for testing
- (void)setItem:(id)item atRow:(NSUInteger)row column:(NSUInteger)col
{
    NSUInteger index = (row * self.columnCount) + col;
    self.values[index] = item;
}

- (NSString *)description
{
    NSMutableString *boardString = [NSMutableString string];
    
    __block NSUInteger col = 0;
    [self.values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (obj == LMBoardItemEmpty)
        {
            [boardString appendString:@"0 "];
        }
        else
        {
            LMBoardItem *item = obj;
            [boardString appendFormat:@"%lu ", (unsigned long)item.level];
        }
        col++;
        
        if (col % self.columnCount == 0)
        {
            [boardString appendString:@"\n"];
        }
    }];
    
    return [NSString stringWithFormat:@"LMBoard: @[\n%@]", boardString];
}

@end
