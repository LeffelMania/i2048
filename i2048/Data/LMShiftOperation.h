//
//  LMShiftOperation.h
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMShiftOperation : NSObject

@property (nonatomic, readonly) BOOL useColumnIndexes;
@property (nonatomic, readonly) BOOL reverseIteration;

+ (LMShiftOperation *)shiftUp;
+ (LMShiftOperation *)shiftDown;
+ (LMShiftOperation *)shiftLeft;
+ (LMShiftOperation *)shiftRight;

@end
