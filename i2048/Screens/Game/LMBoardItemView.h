//
//  LMBoardItemView.h
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMBoardItem.h"

@class LMBoardItem;

@interface LMBoardItemView : UIView

@property (nonatomic, weak) LMBoardItem *boardItem;

- (void)refreshUiForCurrentLevel;

- (void)willUpdateFromBoardShift;
- (void)didUpdateFromBoardShift;

+ (NSString *)accessibilityValueForRow:(NSUInteger)row column:(NSUInteger)column level:(LMBoardItemLevel)level;

@end
