//
//  LMShiftOperation.m
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMShiftOperation.h"

@interface LMShiftOperation ()

@property (nonatomic, assign) BOOL useColumnIndexes;
@property (nonatomic, assign) BOOL reverseIteration;

@end

@implementation LMShiftOperation

- (instancetype)initWithRows:(BOOL)rows useReverse:(BOOL)reverse
{
    self = [super init];
    if (self)
    {
        self.useColumnIndexes = rows;
        self.reverseIteration = reverse;
    }
    return self;
}

+ (LMShiftOperation *)shiftUp
{
    static LMShiftOperation *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LMShiftOperation alloc] initWithRows:YES useReverse:NO];
    });
    
    return instance;
}

+ (LMShiftOperation *)shiftDown
{
    static LMShiftOperation *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LMShiftOperation alloc] initWithRows:YES useReverse:YES];
    });
    
    return instance;
}

+ (LMShiftOperation *)shiftLeft
{
    static LMShiftOperation *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LMShiftOperation alloc] initWithRows:NO useReverse:NO];
    });
    
    return instance;
}

+ (LMShiftOperation *)shiftRight
{
    static LMShiftOperation *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LMShiftOperation alloc] initWithRows:NO useReverse:YES];
    });
    
    return instance;
}

@end
