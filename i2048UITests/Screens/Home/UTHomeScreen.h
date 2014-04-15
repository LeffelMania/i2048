//
//  UTHomeScreen.h
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "UTTestScreen.h"

@class UTGameScreen;

@interface UTHomeScreen : UTTestScreen

- (UTGameScreen *)goToGame;

- (void)setRows:(NSUInteger)rows;
- (void)setColumns:(NSUInteger)columns;
- (void)setSeedCount:(NSUInteger)seeds;

@end
