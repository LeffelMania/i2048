//
//  LMBoardItemView.m
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMBoardItemView.h"

#import "LMBoardItem.h"

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
}

#pragma mark - Public Interface

- (void)setBoardItem:(LMBoardItem *)item
{
    _boardItem = item;
    
    [self refreshUiForCurrentLevel];
}

- (void)refreshUiForCurrentLevel
{
    self.displayedLevel = self.boardItem.level;
    
    NSUInteger value = pow(2, self.boardItem.level + 1);
    self.valueLabel.text = [NSString stringWithFormat:@"%i", value];
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
    if (self.displayedLevel == self.boardItem.level)
    {
        return;
    }
    
    [self pulseDown];
}

#pragma mark - Private Utility

- (void)pulseUp
{
    CABasicAnimation *pulse = [self pulseAnimationFromScale:1.0f toScale:kPulseScale];
    
    [self.layer addAnimation:pulse forKey:@"pulseUp"];
}

- (void)pulseDown
{
    CABasicAnimation *pulse = [self pulseAnimationFromScale:kPulseScale toScale:1.0f];
    
    [self.layer addAnimation:pulse forKey:@"pulseDown"];
}

- (CABasicAnimation *)pulseAnimationFromScale:(CGFloat)fromScale toScale:(CGFloat)toScale
{
    CABasicAnimation *anim;
    
    anim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration = (kPulseDuration / 2);
    anim.autoreverses = NO;
    anim.removedOnCompletion = NO;
    anim.fromValue = [NSNumber numberWithFloat:fromScale];
    anim.toValue = [NSNumber numberWithFloat:toScale];
    
    return anim;
}

@end
