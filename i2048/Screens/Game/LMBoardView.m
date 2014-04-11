//
//  LMGameView.m
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoardView.h"

#import "LMBoard.h"
#import "LMBoardItem.h"

#import "LMBoardItemView.h"

@interface LMBoardView ()

@property (nonatomic, strong) NSMutableArray *itemViews;

@end

@implementation LMBoardView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.itemViews = [NSMutableArray array];
}

- (void)setBoard:(LMBoard *)board
{
    for (LMBoardItemView *view in self.itemViews)
    {
        [view removeFromSuperview];
    }
    [self.itemViews removeAllObjects];
    
    _board = board;
    
    CGFloat spacing = 10;
    CGFloat itemWidth = ((self.frame.size.width - spacing) / self.board.rowCount) - spacing;
    
    UINib *nib = [UINib nibWithNibName:@"LMBoardItemView" bundle:nil];
    
    CGFloat y = spacing;
    
    for (NSUInteger row = 0; row < self.board.rowCount; row++)
    {
        CGFloat x = spacing;
        
        for (NSUInteger col = 0; col < self.board.columnCount; col++)
        {
            LMBoardItem *item = [self.board itemAtRow:row column:col];
            
            LMBoardItemView *itemView = [nib instantiateWithOwner:nil options:nil][0];
            [self addSubview:itemView];
            
            itemView.boardItem = item;
            
            itemView.frame = CGRectMake(x, y, itemWidth, itemWidth);
            
            x += itemWidth + spacing;
        }
        
        y += itemWidth + spacing;
    }
}

@end
