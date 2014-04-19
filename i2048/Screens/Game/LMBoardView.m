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

#import "UIView+FrameUtil.h"

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
    
    self.itemLayoutNib = [UINib nibWithNibName:@"LMBoardItemView" bundle:nil];
}

- (void)setBoard:(LMBoard *)board
{
    NSAssert(self.board == nil, @"Board has already been set for this view.");
    
    _board = board;
    
    NSUInteger maxItemCount = MAX(self.board.columnCount, self.board.rowCount);
    self.itemSize = ((self.frame.size.width - kItemSpacing) / maxItemCount) - kItemSpacing;
    
    for (NSUInteger row = 0; row < self.board.rowCount; row++)
    {
        for (NSUInteger col = 0; col < self.board.columnCount; col++)
        {
            UIView *emptyView = [self createEmptyItemView];
            [self moveView:emptyView toRow:row column:col];
            
            [self.emptyLayer addSubview:emptyView];
            
            LMBoardItem *item = [self.board itemAtRow:row column:col];
            [self addBoardItem:item animated:NO];
        }
    }
}

- (void)updateBoardWithNewItem:(LMBoardItem *)newItem
{
    NSMutableArray *toRemove = [NSMutableArray array];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         
                         for (LMBoardItemView *view in self.itemLayer.subviews)
                         {
                             LMBoardItem *item = view.boardItem;
                             
                             if (![item isAlive])
                             {
                                 view.alpha = 0;
                                 [toRemove addObject:view];
                                 
                                 item = item.parent;
                             }
                             
                             [view willUpdateFromBoardShift];
                             [self moveView:view toRow:item.row column:item.column];
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         for (UIView *remove in toRemove)
                         {
                             [remove removeFromSuperview];
                         }
                         
                         for (LMBoardItemView *view in self.itemLayer.subviews)
                         {
                             [view didUpdateFromBoardShift];
                         }
                         
                         [self addBoardItem:newItem animated:YES];
                     }];
}

#pragma mark - Private Utility

- (UIView *)createEmptyItemView
{
    CGRect frame = CGRectMake(0, 0, self.itemSize, self.itemSize);
    
    UIView *emptyView = [[UIView alloc] initWithFrame:frame];
    emptyView.backgroundColor = [UIColor whiteColor];
    emptyView.roundedCorners = YES;
    
    return emptyView;
}

- (void)addBoardItem:(LMBoardItem *)item animated:(BOOL)animated
{
    if (item)
    {
        LMBoardItemView *itemView = [self createViewForItem:item];
        [self moveView:itemView toRow:item.row column:item.column];
        
        [self.itemLayer addSubview:itemView];
        
        if (animated)
        {
            [self animateViewEntry:itemView];
        }
    }
}

- (void)animateViewEntry:(UIView *)view
{
    CABasicAnimation *anim;
    
    anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration = .125;
    anim.fromValue = [NSNumber numberWithFloat:0];
    anim.toValue = [NSNumber numberWithFloat:1.0];
    
    [view.layer addAnimation:anim forKey:@"entryScale"];
}

- (LMBoardItemView *)createViewForItem:(LMBoardItem *)item
{
    LMBoardItemView *view = [self.itemLayoutNib instantiateWithOwner:nil options:nil][0];
    view.boardItem = item;
    view.size = CGSizeMake(self.itemSize, self.itemSize);
    
    return view;
}

- (void)moveView:(UIView *)view toRow:(NSUInteger)row column:(NSUInteger)col
{
    CGFloat x = kItemSpacing + (col * (self.itemSize + kItemSpacing));
    CGFloat y = kItemSpacing + (row * (self.itemSize + kItemSpacing));
    
    view.origin = CGPointMake(x, y);
}

@end
