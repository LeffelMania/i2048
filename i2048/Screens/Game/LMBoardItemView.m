//
//  LMBoardItemView.m
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoardItemView.h"

#import "LMBoardItem.h"
#import "UIView+FrameUtil.h"

static CGFloat const kPulseDuration = .25;
static CGFloat const kPulseScale = 1.15;

@interface LMBoardItemView ()

@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@property (nonatomic, assign) LMBoardItemLevel displayedLevel;

@end

@implementation LMBoardItemView

- (void)awakeFromNib
{
    self.displayedLevel = -1;
    
    self.roundedCorners = YES;
}

#pragma mark - Public Interface

- (void)setBoardItem:(LMBoardItem *)item
{
    _boardItem = item;
    
    [self refreshUiForCurrentLevel];
    [self refreshAccessibilityValue];
}

- (void)willUpdateFromBoardShift
{
    if (self.displayedLevel == self.boardItem.level)
    {
        return;
    }
    
    [self pulseUp];
    [self refreshUiForCurrentLevel];
}

- (void)didUpdateFromBoardShift
{
    [self refreshAccessibilityValue];
}

+ (NSString *)accessibilityValueForRow:(NSUInteger)row column:(NSUInteger)column level:(LMBoardItemLevel)level
{
    return [NSString stringWithFormat:@"%lu,%lu - %lu", (unsigned long)row, (unsigned long)column, (unsigned long)level];
}

#pragma mark - Private Utility

- (void)refreshUiForCurrentLevel
{
    self.displayedLevel = self.boardItem.level;
    
    self.valueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.boardItem.value];
}

- (void)refreshAccessibilityValue
{
    self.accessibilityValue = [LMBoardItemView accessibilityValueForRow:self.boardItem.row column:self.boardItem.column level:self.boardItem.level];
}

- (void)pulseUp
{
    CABasicAnimation *pulse = [self pulseAnimationFromScale:1.0f toScale:kPulseScale];
    
    [self.layer addAnimation:pulse forKey:@"pulseUp"];
}

- (CABasicAnimation *)pulseAnimationFromScale:(CGFloat)fromScale toScale:(CGFloat)toScale
{
    CABasicAnimation *anim;
    
    anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration = (kPulseDuration / 2);
    anim.autoreverses = YES;
    anim.removedOnCompletion = NO;
    anim.fromValue = [NSNumber numberWithFloat:fromScale];
    anim.toValue = [NSNumber numberWithFloat:toScale];
    
    return anim;
}

@end
