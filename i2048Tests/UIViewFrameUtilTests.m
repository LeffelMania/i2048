//
//  UTFrameUtilTests.m
//  Remind101
//
//  Created by Alex Leffelman on 2/11/14.
//  Copyright (c) 2014 Remind101. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UIView+FrameUtil.h"

static CGFloat X = 10;
static CGFloat Y = 10;
static CGFloat WIDTH = 100;
static CGFloat HEIGHT = 100;

@interface UIViewFrameUtilTests : XCTestCase

@property (nonatomic) UIView *view;

- (void)verifyRectHasX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end

@implementation UIViewFrameUtilTests

- (void)setUp
{
    [super setUp];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(X, Y, WIDTH, HEIGHT)];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Setters

- (void)verifyRectHasX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    XCTAssert(self.view.frame.origin.x == x, @"Expected x = %.1f, got %.1f", x, self.view.frame.origin.x);
    XCTAssert(self.view.frame.origin.y == y, @"Expected y = %.1f, got %.1f", x, self.view.frame.origin.y);
    XCTAssert(self.view.frame.size.width == width, @"Expected width = %.1f, got %.1f", x, self.view.frame.size.width);
    XCTAssert(self.view.frame.size.height == height, @"Expected height = %.1f, got %.1f", x, self.view.frame.size.height);
}

- (void)testSetOrigin
{
    self.view.origin = CGPointMake(0, 0);
    [self verifyRectHasX:0 y:0 width:WIDTH height:HEIGHT];
}

- (void)testSetSize
{
    self.view.size = CGSizeMake((WIDTH / 2), (HEIGHT / 2));
    [self verifyRectHasX:X y:Y width:(WIDTH / 2) height:(HEIGHT / 2)];
}

- (void)testSetX
{
    self.view.x = 0;
    [self verifyRectHasX:0 y:Y width:WIDTH height:HEIGHT];
}

- (void)testSetY
{
    self.view.y = 0;
    [self verifyRectHasX:X y:0 width:WIDTH height:HEIGHT];
}

- (void)testSetWidth
{
    self.view.width = (WIDTH / 2);
    [self verifyRectHasX:X y:Y width:(WIDTH / 2) height:HEIGHT];
}

- (void)testSetHeight
{
    self.view.height = (HEIGHT / 2);
    [self verifyRectHasX:X y:Y width:WIDTH height:(HEIGHT / 2)];
}

- (void)testSetLeft
{
    self.view.left = 0;
    [self verifyRectHasX:0 y:Y width:WIDTH + X height:HEIGHT];
}

- (void)testSetRight
{
    self.view.right = X * 2;
    [self verifyRectHasX:X y:Y width:X height:HEIGHT];
}

- (void)testSetTop
{
    self.view.top = 0;
    [self verifyRectHasX:X y:0 width:WIDTH height:HEIGHT + Y];
}

- (void)testSetBottom
{
    self.view.bottom = Y * 2;
    [self verifyRectHasX:X y:Y width:WIDTH height:Y];
}

#pragma mark - Getters

- (void)testOriginReturnsOriginXandY
{
    CGPoint origin = self.view.origin;
    XCTAssert(origin.x == X, @"");
    XCTAssert(origin.y == Y, @"");
}

- (void)testSizeReturnsSize
{
    CGSize size = self.view.size;
    XCTAssert(size.width == WIDTH, @"");
    XCTAssert(size.height == HEIGHT, @"");
}

- (void)testXReturnsOriginX
{
    XCTAssert(self.view.x == X, @"");
}

- (void)testYReturnsOriginY
{
    XCTAssert(self.view.y == Y, @"");
}

- (void)testWidthReturnsSizeWidth
{
    XCTAssert(self.view.width == WIDTH, @"");
}

- (void)testHeightReturnsSizeHeight
{
    XCTAssert(self.view.height == HEIGHT, @"");
}

- (void)testLeftReturnsOriginX
{
    XCTAssert(self.view.left == X, @"");
}

- (void)testRightReturnsXPlusWidth
{
    XCTAssert(self.view.right == (X + WIDTH), @"");
}

- (void)testTopReturnsOriginY
{
    XCTAssert(self.view.top == Y, @"");
}

- (void)testBottomReturnsYPlusHeight
{
    XCTAssert(self.view.bottom == (Y + HEIGHT), @"");
}

- (void)testRoundedCornersAdjustsCornerRadius
{
    self.view.layer.cornerRadius = 0;
    self.view.roundedCorners = YES;
    XCTAssert(self.view.layer.cornerRadius != 0, @"");
}

- (void)testRoundedCornersReturnsTrueIfCornerRadiusNotZero
{
    self.view.layer.cornerRadius = 1;
    XCTAssert(self.view.roundedCorners, "");
}

- (void)testRoundedCornersReturnsFalseIfCornerRadiusIsZero
{
    self.view.layer.cornerRadius = 0;
    XCTAssert(!self.view.roundedCorners, "");
}

@end
