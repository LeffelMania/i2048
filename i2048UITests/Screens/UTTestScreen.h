//
//  UTTestScreen.h
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "KIFUITestActor.h"

@interface UTTestScreen : KIFUITestActor

@property (nonatomic, readonly) NSString *idenitifyingLabel;

- (void)assertVisible;

@end
