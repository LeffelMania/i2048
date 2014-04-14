//
//  LMShiftResult.m
//  i2048
//
//  Created by Alex Leffelman on 4/13/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMShiftResult.h"

#import "LMBoardItem.h"

@interface LMShiftResult ()

@property (nonatomic, strong) NSArray *matchedItems;
@property (nonatomic, strong) LMBoardItem *addedItem;

@end

@implementation LMShiftResult

- (instancetype)initWithMatches:(NSArray *)matches addition:(LMBoardItem *)addition
{
    self = [super init];
    if (self)
    {
        self.matchedItems = matches;
        self.addedItem = addition;
    }
    return self;
}

@end
