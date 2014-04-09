//
//  LMGameViewController.h
//  i2048
//
//  Created by Alex Leffelman on 4/8/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMBoard;

@interface LMGameViewController : UIViewController

- (instancetype)initWithBoard:(LMBoard *)board;

@end
