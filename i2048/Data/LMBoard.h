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

@property (nonatomic, readonly) NSUInteger rowCount;
@property (nonatomic, readonly) NSUInteger columnCount;

- (instancetype)initWithSize:(NSUInteger)size;
- (instancetype)initWithSize:(NSUInteger)size values:(NSArray *)valueArray;
- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols;
- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols values:(NSArray *)valueArray;

- (LMBoardItem *)itemAtRow:(NSUInteger)row column:(NSUInteger)column;

- (BOOL)canShiftUp;
- (BOOL)canShiftDown;
- (BOOL)canShiftLeft;
- (BOOL)canShiftRight;

- (void)shiftUp;
- (void)shiftDown;
- (void)shiftLeft;
- (void)shiftRight;

- (BOOL)isFull;
- (BOOL)hasMatches;

@end
