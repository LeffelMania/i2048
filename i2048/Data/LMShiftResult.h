//
//  LMShiftResult.h
//  i2048
//
//  Created by Alex Leffelman on 4/12/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMBoardItem;
@class LMBoardEvent;

@interface LMShiftResult : NSObject

@property (nonatomic, readonly) NSArray *matches;
@property (nonatomic, readonly) NSArray *moves;
@property (nonatomic, readonly) LMBoardItem *addition;

- (instancetype)initWithMatches:(NSArray *)matches moves:(NSArray *)moves addition:(LMBoardItem *)addition;

@end

@interface LMBoardEvent : NSObject

@property (nonatomic, readonly) LMBoardItem *fromItem;
@property (nonatomic, readonly) LMBoardItem *toItem;

- (instancetype)initWithFromItem:(LMBoardItem *)fromItem toItem:(LMBoardItem *)toItem;

@end
