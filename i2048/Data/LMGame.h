//
//  LMGame.h
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMBoard;
@class LMBoardItem;

@interface LMGame : NSObject

@property (nonatomic, strong, readonly) LMBoard *board;
@property (nonatomic, readonly) NSUInteger score;

- (instancetype)initWithBoard:(LMBoard *)board;

- (LMBoardItem *)shiftUp;
- (LMBoardItem *)shiftDown;
- (LMBoardItem *)shiftLeft;
- (LMBoardItem *)shiftRight;

- (BOOL)isOver;

@end
