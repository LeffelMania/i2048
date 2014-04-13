//
//  LMBoardItemView.m
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoardItemView.h"

#import "LMBoardItem.h"

@interface LMBoardItemView ()

@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@end

@implementation LMBoardItemView

- (void)dealloc
{
}

- (void)awakeFromNib
{
}

- (void)setBoardItem:(LMBoardItem *)boardItem
{
    [self setBoardItem:boardItem animated:NO];
}

- (void)setBoardItem:(LMBoardItem *)item animated:(BOOL)animated
{
    _boardItem = item;
    
    [self refreshLevel];
}

- (void)refreshLevel
{
    [self refreshLevelAnimated:NO];
}

- (void)refreshLevelAnimated:(BOOL)animated
{
    self.valueLabel.text = [NSString stringWithFormat:@"%i", (self.boardItem.level + 1)];
}

@end
