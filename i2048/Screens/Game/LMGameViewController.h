//
//  LMGameViewController.h
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMGame;

@interface LMGameViewController : UIViewController

- (instancetype)initWithGame:(LMGame *)game;

@end
