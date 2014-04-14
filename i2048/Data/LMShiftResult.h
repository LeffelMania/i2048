//
//  LMShiftResult.h
//  i2048
//
//  Created by Alex Leffelman on 4/13/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMBoardItem;

@interface LMShiftResult : NSObject

@property (nonatomic, readonly) NSArray *matchedItems;
@property (nonatomic, readonly) LMBoardItem *addedItem;

- (instancetype)initWithMatches:(NSArray *)matches addition:(LMBoardItem *)addition;

@end
