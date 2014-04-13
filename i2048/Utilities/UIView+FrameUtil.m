#import "UIView+FrameUtil.h"

@implementation UIView (FrameUtil)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    NSAssert(left <= self.right, @"Cannot set frame's left to the right of frame's right");
    
    CGFloat newWidth = self.right - left;
    self.frame = CGRectMake(left, self.frame.origin.y, newWidth, self.frame.size.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    NSAssert(right >= self.left, @"Cannot set frame's right to the left of frame's left");
    
    CGFloat newWidth = right - self.left;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newWidth, self.frame.size.height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    NSAssert(top <= self.bottom, @"Cannot set frame's top below frame's bottom");
    
    CGFloat newHeight = self.bottom - top;
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, newHeight);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    NSAssert(bottom >= self.top, @"Cannot set frame's bottom above frame's top");
    
    CGFloat newHeight = bottom - self.top;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
}

@end