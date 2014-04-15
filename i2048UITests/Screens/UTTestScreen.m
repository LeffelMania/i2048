//
//  UTTestScreen.m
//  i2048
//
//  Created by Alex Leffelman on 4/14/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "UTTestScreen.h"

@implementation UTTestScreen

- (void)assertVisible
{
    [[self usingTimeout:2] waitForViewWithAccessibilityLabel:self.idenitifyingLabel];
}

- (NSString *)idenitifyingLabel
{
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

- (void)failWithError:(NSError *)error stopTest:(BOOL)stopTest
{
    NSLog(@"%@", error);
    if (stopTest)
    {
        NSLog(@"lulzwat?");
    }
}

- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop
{
    NSException *exception = [exceptions firstObject];
    NSLog(@"%@", exception);
    if (stop)
    {
        [exception raise];
    }
}

@end
