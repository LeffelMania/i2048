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
    [self stopListeningToLevel];
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
    [self stopListeningToLevel];
    
    _boardItem = item;
    [self.boardItem addObserver:self forKeyPath:@"level" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self refreshLevel];
}

- (void)refreshLevel
{
    if ([self.boardItem isEmpty])
    {
        self.valueLabel.text = @"";
    }
    else
    {
        self.valueLabel.text = [NSString stringWithFormat:@"%i", self.boardItem.level];
    }
}

- (void)stopListeningToLevel
{
    if (self.boardItem)
    {
        [self.boardItem removeObserver:self forKeyPath:@"level"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"level"])
    {
        [self refreshLevel];
    }
}

@end
