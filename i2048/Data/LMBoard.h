//
//  LMBoard.h
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMBoardItem;

typedef BOOL(^LMBoardIterationBlock)(LMBoardItem *item);

@interface LMBoard : NSObject

@property (nonatomic, readonly) NSUInteger size;

- (instancetype)initWithSize:(NSUInteger)size;
- (instancetype)initWithSize:(NSUInteger)size values:(NSArray *)valueArray;

- (LMBoardItem *)itemAtRow:(NSUInteger)row column:(NSUInteger)column;

- (void)iterateBoardWithBlock:(LMBoardIterationBlock)block;
- (void)iterateRow:(NSUInteger)row withBlock:(LMBoardIterationBlock)block;
- (void)iterateColumn:(NSUInteger)col withBlock:(LMBoardIterationBlock)block;

- (BOOL)isFull;
- (BOOL)isRowFull:(NSUInteger)row;
- (BOOL)isColumnFull:(NSUInteger)col;

@end
