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

@property (nonatomic, assign) NSUInteger size;

@property (nonatomic, strong) NSMutableArray *values;

@end

@implementation LMBoard

- (instancetype)initWithSize:(NSUInteger)size
{
    return [self initWithSize:size values:nil];
}

- (instancetype)initWithSize:(NSUInteger)size values:(NSArray *)valueArray
{
    self = [super init];
    if (self)
    {
        self.size = size;
        self.values = [self createBoard];
        
        if (valueArray)
        {
            NSAssert([valueArray count] == [self count], @"Expected %u items in provided values array, got %u", [self count], [valueArray count]);
            
            __block NSUInteger index = 0;
            [self iterateBoardWithBlock:^BOOL(LMBoardItem *item) {
                
                item.level = [valueArray[index] integerValue];
                index++;
                
                return NO;
            }];
        }
    }
    return self;
}

#pragma mark - Public Interface

- (LMBoardItem *)itemAtRow:(NSUInteger)row column:(NSUInteger)column
{
    if (row >= self.size || column >= self.size)
    {
        return nil;
    }
    
    return self.values[row][column];
}

- (BOOL)isFull
{
    __block BOOL result = YES;
    
    [self iterateBoardWithBlock:^BOOL(LMBoardItem *item) {
        
        if ([item isEmpty])
        {
            result = NO;
            return YES;
        }
        
        return NO;
    }];
    
    return result;
}

- (BOOL)hasMatches
{
    __block BOOL canReturnYes = NO;
    
    // Left/Right Matches
    for (NSUInteger row = 0; row < self.size; row++)
    {
        __block LMBoardItemLevel prevLevel = LMBoardItemEmpty;
        [self iterateRow:row withBlock:^BOOL(LMBoardItem *item) {
            
            if (prevLevel != LMBoardItemEmpty && item.level == prevLevel)
            {
                canReturnYes = YES;
                return YES;
            }
            prevLevel = item.level;
            
            return NO;
        }];
        
        if (canReturnYes)
        {
            return YES;
        }
    }
    
    // Up/Down Matches
    for (NSUInteger col = 0; col < self.size; col++)
    {
        __block LMBoardItemLevel prevLevel = LMBoardItemEmpty;
        [self iterateColumn:col withBlock:^BOOL(LMBoardItem *item) {
            
            if (prevLevel != LMBoardItemEmpty && item.level == prevLevel)
            {
                canReturnYes = YES;
                return YES;
            }
            prevLevel = item.level;
            
            return NO;
        }];
        
        if (canReturnYes)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftUp
{
    for (NSUInteger col = 0; col < self.size; col++)
    {
        __block BOOL wasEmpty = NO;
        __block BOOL canReturnYes = NO;
        
        [self iterateColumn:col withBlock:^BOOL(LMBoardItem *item) {
            
            BOOL isEmpty = [item isEmpty];
            if (wasEmpty && !isEmpty)
            {
                canReturnYes = YES;
                return YES;
            }
            
            wasEmpty = isEmpty;
            
            return NO;
        }];
        
        if (canReturnYes)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftDown
{
    for (NSUInteger col = 0; col < self.size; col++)
    {
        __block BOOL wasEmpty = YES;
        __block BOOL canReturnYes = NO;
        
        [self iterateColumn:col withBlock:^BOOL(LMBoardItem *item) {
            
            BOOL isEmpty = [item isEmpty];
            if (!wasEmpty && isEmpty)
            {
                canReturnYes = YES;
                return YES;
            }
            
            wasEmpty = isEmpty;
            
            return NO;
        }];
        
        if (canReturnYes)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftLeft
{
    for (NSUInteger row = 0; row < self.size; row++)
    {
        __block BOOL wasEmpty = NO;
        __block BOOL canReturnYes = NO;
        
        [self iterateRow:row withBlock:^BOOL(LMBoardItem *item) {
            
            BOOL isEmpty = [item isEmpty];
            if (wasEmpty && !isEmpty)
            {
                canReturnYes = YES;
                return YES;
            }
            
            wasEmpty = isEmpty;
            
            return NO;
        }];
        
        if (canReturnYes)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canShiftRight
{
    for (NSUInteger row = 0; row < self.size; row++)
    {
        __block BOOL wasEmpty = YES;
        __block BOOL canReturnYes = NO;
        
        [self iterateRow:row withBlock:^BOOL(LMBoardItem *item) {
            
            BOOL isEmpty = [item isEmpty];
            if (!wasEmpty && isEmpty)
            {
                canReturnYes = YES;
                return YES;
            }
            
            wasEmpty = isEmpty;
            
            return NO;
        }];
        
        if (canReturnYes)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)shiftUp
{
    for (NSUInteger col = 0; col < self.size; col++)
    {
        // Consolidate Matches
        __block LMBoardItem *toMatch = nil;
        [self iterateColumn:col withBlock:^BOOL(LMBoardItem *item) {
            
            if (!toMatch && ![item isEmpty])
            {
                toMatch = item;
                return NO;
            }
            
            if ([item matches:toMatch])
            {
                [toMatch advance];
                [item clear];
                
                toMatch = nil;
            }
            
            return NO;
        }];
        
        // Shift Up
        __block LMBoardItem *toFill = nil;
        [self iterateColumn:col withBlock:^BOOL(LMBoardItem *item) {
            
            if (!toFill)
            {
                if ([item isEmpty])
                {
                    toFill = item;
                }
                return NO;
            }
            
            if (![item isEmpty])
            {
                toFill.level = item.level;
                [item clear];
                
                toFill = item;
            }
            
            return NO;
        }];
    }
    
    [self insertNewItem];
}

- (void)shiftDown
{
    for (NSUInteger col = 0; col < self.size; col++)
    {
        // Consolidate Matches
        LMBoardItem *toMatch = nil;
        for (NSInteger row = self.size - 1; row >= 0; row--)
        {
            LMBoardItem *item = [self itemAtRow:row column:col];
            
            if (!toMatch && ![item isEmpty])
            {
                toMatch = item;
                continue;
            }
            
            if ([item matches:toMatch])
            {
                [toMatch advance];
                [item clear];
                
                toMatch = nil;
            }
        }
        
        // Shift Down
        LMBoardItem *toFill = nil;
        for (NSInteger row = self.size - 1; row >= 0; row--)
        {
            LMBoardItem *item = [self itemAtRow:row column:col];
            
            if (!toFill)
            {
                if ([item isEmpty])
                {
                    toFill = item;
                }
                continue;
            }
            
            if (![item isEmpty])
            {
                toFill.level = item.level;
                [item clear];
                
                toFill = item;
            }
        }
    }
    
    [self insertNewItem];
}

- (void)shiftLeft
{
    for (NSUInteger row = 0; row < self.size; row++)
    {
        // Consolidate Matches
        LMBoardItem *toMatch = nil;
        for (NSInteger col = self.size - 1; col >= 0; col--)
        {
            LMBoardItem *item = [self itemAtRow:row column:col];
            
            if (!toMatch && ![item isEmpty])
            {
                toMatch = item;
                continue;
            }
            
            if ([item matches:toMatch])
            {
                [toMatch advance];
                [item clear];
                
                toMatch = nil;
            }
        }
        
        // Shift Left
        LMBoardItem *toFill = nil;
        for (NSInteger col = 0; col < self.size; col++)
        {
            LMBoardItem *item = [self itemAtRow:row column:col];
            
            if (!toFill)
            {
                if ([item isEmpty])
                {
                    toFill = item;
                }
                continue;
            }
            
            if (![item isEmpty])
            {
                toFill.level = item.level;
                [item clear];
                
                toFill = item;
            }
        }
    }
    
    [self insertNewItem];
}

- (void)shiftRight
{
    for (NSUInteger row = 0; row < self.size; row++)
    {
        // Consolidate Matches
        LMBoardItem *toMatch = nil;
        for (NSInteger col = 0; col < self.size; col++)
        {
            LMBoardItem *item = [self itemAtRow:row column:col];
            
            if (!toMatch && ![item isEmpty])
            {
                toMatch = item;
                continue;
            }
            
            if ([item matches:toMatch])
            {
                [toMatch advance];
                [item clear];
                
                toMatch = nil;
            }
        }
        
        // Shift Left
        LMBoardItem *toFill = nil;
        for (NSInteger col = self.size - 1; col >= 0; col--)
        {
            LMBoardItem *item = [self itemAtRow:row column:col];
            
            if (!toFill)
            {
                if ([item isEmpty])
                {
                    toFill = item;
                }
                continue;
            }
            
            if (![item isEmpty])
            {
                toFill.level = item.level;
                [item clear];
                
                toFill = item;
            }
        }
    }
    
    [self insertNewItem];
}

#pragma mark - Private Utility

- (NSMutableArray *)createBoard
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSUInteger row = 0; row < self.size; row++)
    {
        NSMutableArray *rowValues = [NSMutableArray array];
        
        for (NSUInteger col = 0; col < self.size; col++)
        {
            [rowValues addObject:[LMBoardItem new]];
        }
        
        [values addObject:rowValues];
    }
    
    return values;
}

- (void)iterateBoardWithBlock:(LMBoardIterationBlock)block
{
    for (NSUInteger row = 0; row < self.size; row++)
    {
        for (NSUInteger col = 0; col < self.size; col++)
        {
            LMBoardItem *item = [self itemAtRow:row column:col];
            
            BOOL stop = block(item);
            if (stop)
            {
                return;
            }
        }
    }
}

- (void)iterateRow:(NSUInteger)row withBlock:(LMBoardIterationBlock)block
{
    for (NSUInteger col = 0; col < self.size; col++)
    {
        LMBoardItem *item = [self itemAtRow:row column:col];
        
        BOOL stop = block(item);
        if (stop)
        {
            return;
        }
    }
}

- (void)iterateColumn:(NSUInteger)col withBlock:(LMBoardIterationBlock)block
{
    for (NSUInteger row = 0; row < self.size; row++)
    {
        LMBoardItem *item = [self itemAtRow:row column:col];
        
        BOOL stop = block(item);
        if (stop)
        {
            return;
        }
    }
}

- (NSUInteger)count
{
    return (self.size * self.size);
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
        NSUInteger row = index / self.size;
        NSUInteger col = index % self.size;
        
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
    
    [self iterateBoardWithBlock:^BOOL(LMBoardItem *item) {
        [boardString appendFormat:@"%u ", item.level];
        return NO;
    }];
    
    return [NSString stringWithFormat:@"LMBoard: @[ %@]", boardString];
}

@end
