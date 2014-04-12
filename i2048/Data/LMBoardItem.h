//
//  LMBoardValue.h
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger LMBoardItemLevel;

FOUNDATION_EXPORT LMBoardItemLevel const LMBoardItemEmpty;

@interface LMBoardItem : NSObject

@property (nonatomic, readonly) NSUInteger row;
@property (nonatomic, readonly) NSUInteger column;
@property (nonatomic, assign) LMBoardItemLevel level;

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column;

- (BOOL)isEmpty;

- (void)clear;
- (LMBoardItemLevel)advance;

- (BOOL)matches:(LMBoardItem *)otherItem;

@end
