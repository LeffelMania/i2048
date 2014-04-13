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
#import "LMShiftResult.h"

#import "LMBoardItemView.h"

static CGFloat const kItemSpacing = 10;

@interface LMBoardView ()

@property (nonatomic, strong) UIView *emptyLayer;
@property (nonatomic, strong) UIView *itemLayer;

@property (nonatomic, assign) CGFloat itemSize;

@end

@implementation LMBoardView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor lightGrayColor];
    
    CGRect layerFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.emptyLayer = [[UIView alloc] initWithFrame:layerFrame];
    self.emptyLayer.backgroundColor = [UIColor clearColor];
    [self addSubview:self.emptyLayer];
    
    self.itemLayer = [[UIView alloc] initWithFrame:layerFrame];
    self.itemLayer.backgroundColor = [UIColor clearColor];
    [self addSubview:self.itemLayer];
}

- (void)setBoard:(LMBoard *)board
{
    for (LMBoardItemView *view in self.itemLayer.subviews)
    {
        [view removeFromSuperview];
    }
    
    _board = board;
    
    self.itemSize = ((self.frame.size.width - kItemSpacing) / self.board.rowCount) - kItemSpacing;
    
    for (NSUInteger row = 0; row < self.board.rowCount; row++)
    {
        for (NSUInteger col = 0; col < self.board.columnCount; col++)
        {
            UIView *emptyView = [self createEmptyItemView];
            [self moveView:emptyView toRow:row column:col];
            
            [self.emptyLayer addSubview:emptyView];
            
            LMBoardItem *item = [self.board itemAtRow:row column:col];
            if (item)
            {
                LMBoardItemView *itemView = [self createItemViewForItem:item];
                [self moveView:itemView toRow:row column:col];
                
                [self.itemLayer addSubview:itemView];
            }
        }
    }
}

- (void)updateWithShiftResult:(LMShiftResult *)shift
{
    NSLog(@"Updating from shift: %@", shift);
    
    NSMutableArray *toRemove = [NSMutableArray array];
    NSMutableArray *toAdvance = [NSMutableArray array];
    
    [UIView animateWithDuration:.25 animations:^{
        
        for (LMBoardEvent *event in shift.moves)
        {
            LMBoardItemView *view = [self itemViewForItem:event.fromItem];
            
            if (view)
            {
                LMBoardItem *to = event.toItem;
                [self moveView:view toRow:to.row column:to.column];
                
                view.boardItem = to;
            }
            else
            {
                NSLog(@"DIDN'T FIND VIEW!");
            }
        }
        
        for (LMBoardEvent *event in shift.matches)
        {
            LMBoardItemView *fromView = [self itemViewForItem:event.fromItem];
            LMBoardItemView *toView = [self itemViewForItem:event.toItem];
            
            if (fromView && toView)
            {
                fromView.frame = toView.frame;
                fromView.alpha = 0;
                [toRemove addObject:fromView];
                
                [toAdvance addObject:toView];
            }
            else
            {
                NSLog(@"DIDN'T FIND VIEWS!");
            }
        }
        
    } completion:^(BOOL finished) {
        
        if (shift.addition)
        {
            LMBoardItemView *newItem = [self createItemViewForItem:shift.addition];
            
            [self.itemLayer addSubview:newItem];
            [self moveView:newItem toRow:shift.addition.row column:shift.addition.column];
        }
        
        for (UIView *remove in toRemove)
        {
            [remove removeFromSuperview];
        }
        
        for (LMBoardItemView *advance in toAdvance)
        {
            [advance refreshLevelAnimated:YES];
        }
    }];
}

#pragma mark - Private Utility

- (UIView *)createEmptyItemView
{
    CGRect frame = CGRectMake(0, 0, self.itemSize, self.itemSize);
    
    UIView *emptyView = [[UIView alloc] initWithFrame:frame];
    emptyView.backgroundColor = [UIColor whiteColor];
    
    return emptyView;
}

- (LMBoardItemView *)createItemViewForItem:(LMBoardItem *)item
{
    static UINib *nib = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nib = [UINib nibWithNibName:@"LMBoardItemView" bundle:nil];
    });
    
    LMBoardItemView *view = [nib instantiateWithOwner:nil options:nil][0];
    view.boardItem = item;
    view.frame = CGRectMake(0, 0, self.itemSize, self.itemSize);
    
    return view;
}

- (LMBoardItemView *)itemViewForItem:(LMBoardItem *)match
{
    for (LMBoardItemView *itemView in self.itemLayer.subviews)
    {
        LMBoardItem *item = itemView.boardItem;
        
        if (item.row == match.row && item.column == match.column)
        {
            return itemView;
        }
    }
    
    return nil;
}

- (void)moveView:(UIView *)view toRow:(NSUInteger)row column:(NSUInteger)col
{
    CGFloat x = kItemSpacing + (col * (view.frame.size.height + kItemSpacing));
    CGFloat y = kItemSpacing + (row * (view.frame.size.width + kItemSpacing));
    
    view.frame = CGRectMake(x,
                            y,
                            view.frame.size.width,
                            view.frame.size.height);
}

@end
