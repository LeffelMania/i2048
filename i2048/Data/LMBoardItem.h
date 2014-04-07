//
//  LMBoardValue.h
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSUInteger const LMBoardItemEmpty;

@interface LMBoardItem : NSObject

@property (nonatomic, assign) NSUInteger level;

- (BOOL)isEmpty;

- (void)clear;
- (NSUInteger)advance;

- (BOOL)matches:(LMBoardItem *)otherItem;

@end
