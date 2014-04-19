//
//  LMHomeViewController.m
//  i2048
//
//  Created by Alex Leffelman on 4/6/14.
//  Copyright (c) 2014 Alex Leffelman. All rights reserved.
//

#import "LMHomeViewController.h"

#import "LMGameViewController.h"

#import "LMBoard.h"
#import "LMGame.h"

@interface LMHomeViewController ()

@property (nonatomic, weak) IBOutlet UISlider *rowSlider;
@property (nonatomic, weak) IBOutlet UISlider *columnSlider;
@property (nonatomic, weak) IBOutlet UISlider *seedSlider;

@property (nonatomic, weak) IBOutlet UILabel *rowLabel;
@property (nonatomic, weak) IBOutlet UILabel *columnLabel;
@property (nonatomic, weak) IBOutlet UILabel *seedLabel;

@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) NSUInteger seeds;

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
    
    [self refreshValues];
}

- (void)refreshValues
{
    self.rows = (NSUInteger)roundf(self.rowSlider.value);
    self.columns = (NSUInteger)roundf(self.columnSlider.value);
    
    NSUInteger max = (self.rows * self.columns);
    
    self.seedSlider.maximumValue = max;
    if (self.seeds > max)
    {
        self.seeds = max;
    }
    else
    {
        self.seeds = (NSUInteger)roundf(self.seedSlider.value);
    }
}

- (void)setRows:(NSUInteger)rows
{
    _rows = rows;
    
    self.rowLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)rows];
}

- (void)setColumns:(NSUInteger)columns
{
    _columns = columns;
    
    self.columnLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)columns];
}

- (void)setSeeds:(NSUInteger)seeds
{
    _seeds = seeds;
    
    self.seedLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)seeds];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    [self refreshValues];
}

- (IBAction)pressedGame:(id)sender
{
    LMBoard *board = [[LMBoard alloc] initWithRows:self.rows columns:self.columns initialItemCount:self.seeds];
    LMGame *game = [[LMGame alloc] initWithBoard:board];
    
    LMGameViewController *vc = [[LMGameViewController alloc] initWithGame:game];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
