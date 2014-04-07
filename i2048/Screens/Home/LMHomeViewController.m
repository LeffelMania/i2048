//
//  LMHomeViewController.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMHomeViewController.h"

@interface LMHomeViewController ()

@end

@implementation LMHomeViewController

- (id)init
{
    self = [super initWithNibName:@"LMHomeViewController" bundle:nil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Hi.";
}

@end
