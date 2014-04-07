//
//  LMAppDelegate.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMAppDelegate.h"

#import "LMHomeViewController.h"

@implementation LMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LMHomeViewController *vc = [LMHomeViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.window setRootViewController:nav];
    
    return YES;
}

@end
