//
//  LMBoardValue.h
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSUInteger LMBoardItemLevel;

#define LMBoardItemEmpty ([NSNull null])

@interface LMBoardItem : NSObject

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger column;
@property (nonatomic, readonly) LMBoardItemLevel level;
@property (nonatomic, readonly) NSUInteger value;

@property (nonatomic, readonly) LMBoardItem *parent;
@property (nonatomic, readonly) BOOL isAlive;

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column;
- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column level:(NSUInteger)level;

- (void)mergeIntoParent:(LMBoardItem *)parent;

- (BOOL)matches:(LMBoardItem *)otherItem;

@end
