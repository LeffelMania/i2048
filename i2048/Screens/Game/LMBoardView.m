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
}

- (void)setBoard:(LMBoard *)board
{
    for (UIView *view in self.emptyLayer.subviews)
    {
        [view removeFromSuperview];
    }
    
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
            [self addBoardItem:item];
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
                             [view refreshLevelAnimated:YES];
                         }
                         
                         [self addBoardItem:newItem];
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

- (void)addBoardItem:(LMBoardItem *)item
{
    if (item)
    {
        LMBoardItemView *itemView = [self createViewForItem:item];
        [self moveView:itemView toRow:item.row column:item.column];
        
        [self.itemLayer addSubview:itemView];
    }
}

- (LMBoardItemView *)createViewForItem:(LMBoardItem *)item
{
    static UINib *nib = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nib = [UINib nibWithNibName:@"LMBoardItemView" bundle:nil];
    });
    
    LMBoardItemView *view = [nib instantiateWithOwner:nil options:nil][0];
    view.boardItem = item;
    view.size = CGSizeMake(self.itemSize, self.itemSize);
    
    return view;
}

- (LMBoardItemView *)viewForItem:(LMBoardItem *)item
{
    for (LMBoardItemView *view in self.itemLayer.subviews)
    {
        if ([view.boardItem isEqual:item])
        {
            return view;
        }
    }
    
    NSAssert(NO, @"Didn't find view for item: %@", item);
    return nil;
}

- (void)moveView:(UIView *)view toRow:(NSUInteger)row column:(NSUInteger)col
{
    CGFloat x = kItemSpacing + (col * (view.width + kItemSpacing));
    CGFloat y = kItemSpacing + (row * (view.height + kItemSpacing));
    
    view.origin = CGPointMake(x, y);
}

@end
