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
            NSAssert([valueArray count] == (size * size), @"Expected %u items in provided values array, got %u", (size * size), [valueArray count]);
            
            __block NSUInteger index = 0;
            [self iterateBoardWithBlock:^BOOL(LMBoardItem *item) {
                
                item.level = [valueArray[index] unsignedIntegerValue];
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

- (void)iterateBoardWithBlock:(LMBoardIterationBlock)block
{
    if (!block)
    {
        return;
    }
    
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
    if (!block || row >= self.size)
    {
        return;
    }
    
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
    if (!block || col >= self.size)
    {
        return;
    }
    
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

- (BOOL)isRowFull:(NSUInteger)row
{
    __block BOOL result = YES;
    
    [self iterateRow:row withBlock:^BOOL(LMBoardItem *item) {
        
        if ([item isEmpty])
        {
            result = NO;
            return YES;
        }
        
        return NO;
    }];
    
    return result;
}

- (BOOL)isColumnFull:(NSUInteger)col
{
    __block BOOL result = YES;
    
    [self iterateColumn:col withBlock:^BOOL(LMBoardItem *item) {
        
        if ([item isEmpty])
        {
            result = NO;
            return YES;
        }
        
        return NO;
    }];
    
    return result;
}

- (NSString *)description
{
    NSMutableString *boardString = [NSMutableString string];
    
    [self iterateBoardWithBlock:^BOOL(LMBoardItem *item) {
        [boardString appendFormat:@"%u ", item.level];
        return NO;
    }];
    
    return [NSString stringWithFormat:@"LMBoard: @@[ %@]", boardString];
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

@end
