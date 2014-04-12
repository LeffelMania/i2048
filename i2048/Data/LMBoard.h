//
//  LMBoard.h
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMBoardItem;
@class LMShiftResult;

@interface LMBoard : NSObject

@property (nonatomic, readonly) NSUInteger rowCount;
@property (nonatomic, readonly) NSUInteger columnCount;

@property (nonatomic, assign) NSUInteger numberOfShiftsPerSeed;

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols;
- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)cols initialItemCount:(NSUInteger)count;

- (LMBoardItem *)itemAtRow:(NSUInteger)row column:(NSUInteger)column;

- (BOOL)canShiftUp;
- (BOOL)canShiftDown;
- (BOOL)canShiftLeft;
- (BOOL)canShiftRight;

- (LMShiftResult *)shiftUp;
- (LMShiftResult *)shiftDown;
- (LMShiftResult *)shiftLeft;
- (LMShiftResult *)shiftRight;

- (BOOL)isFull;
- (BOOL)hasMatches;

@end
