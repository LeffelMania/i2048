//
//  LMShiftResult.m
//  i2048
//
//  Created by Alex Leffelman on 4/12/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMShiftResult.h"

@interface LMShiftResult ()

@property (nonatomic, strong) NSArray *matches;
@property (nonatomic, strong) NSArray *moves;

@end

@implementation LMShiftResult

- (instancetype)initWithMatches:(NSArray *)matches moves:(NSArray *)moves
{
    self = [super init];
    if (self)
    {
        self.matches = matches;
        self.moves = moves;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"LMShiftResult: Matches:{\n%@}\nMoves:{\n%@}", self.matches, self.moves];
}

@end

@interface LMBoardEvent ()

@property (nonatomic, strong) LMBoardItem *fromItem;
@property (nonatomic, strong) LMBoardItem *toItem;

@end

@implementation LMBoardEvent

- (instancetype)initWithFromItem:(LMBoardItem *)fromItem toItem:(LMBoardItem *)toItem
{
    self = [super init];
    if (self)
    {
        self.fromItem = fromItem;
        self.toItem = toItem;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"LMBoardEvent: from (%@) to (%@)", self.fromItem, self.toItem];
}

@end
