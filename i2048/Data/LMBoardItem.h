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

@property (nonatomic, assign) LMBoardItemLevel level;

- (BOOL)isEmpty;

- (void)clear;
- (LMBoardItemLevel)advance;

- (BOOL)matches:(LMBoardItem *)otherItem;

@end
