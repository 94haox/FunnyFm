//
//  UIButton+SomeMethods.m
//  MyDBang
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 Ziteng. All rights reserved.
//

#import "UIButton+SomeMethods.h"
#import <objc/runtime.h>

@implementation UIButton (SomeMethods)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;


- (void)dw_titleImageHorizontalAlignmentWithSpace:(float)space;
{
  [self dw_resetEdgeInsets];
  [self setNeedsLayout];
  [self layoutIfNeeded];
  
  CGRect contentRect = [self contentRectForBounds:self.bounds];
  CGSize titleSize = [self titleRectForContentRect:contentRect].size;
  CGSize imageSize = [self imageRectForContentRect:contentRect].size;
  
  [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
  [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width)];
  [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width+space, 0, -titleSize.width - space)];
}

- (void)dw_imageTitleHorizontalAlignmentWithSpace:(float)space;
{
  [self dw_resetEdgeInsets];
  [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
  [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
}

- (void)dw_titleImageVerticalAlignmentWithSpace:(float)space;
{
  [self dw_verticalAlignmentWithTitleTop:YES space:space];
}

- (void)dw_imageTitleVerticalAlignmentWithSpace:(float)space;
{
  [self dw_verticalAlignmentWithTitleTop:NO space:space];
}

- (void)dw_verticalAlignmentWithTitleTop:(BOOL)isTop space:(float)space ;
{
  [self dw_resetEdgeInsets];
  [self setNeedsLayout];
  [self layoutIfNeeded];
  
  CGRect contentRect = [self contentRectForBounds:self.bounds];
  CGSize titleSize = [self titleRectForContentRect:contentRect].size;
  CGSize imageSize = [self imageRectForContentRect:contentRect].size;
  
  float halfWidth = (titleSize.width + imageSize.width)/2;
  float halfHeight = (titleSize.height + imageSize.height)/2;
  
  float topInset = MIN(halfHeight, titleSize.height);
  float leftInset = (titleSize.width - imageSize.width)>0?(titleSize.width - imageSize.width)/2:0;
  float bottomInset = (titleSize.height - imageSize.height)>0?(titleSize.height - imageSize.height)/2:0;
  float rightInset = MIN(halfWidth, titleSize.width);
  
  if (isTop) {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(-halfHeight-space, - halfWidth, halfHeight+space, halfWidth)];
    [self setContentEdgeInsets:UIEdgeInsetsMake(topInset+space, leftInset, -bottomInset, -rightInset)];
  } else {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(halfHeight+space, - halfWidth, -halfHeight-space, halfWidth)];
    [self setContentEdgeInsets:UIEdgeInsetsMake(-bottomInset, leftInset, topInset+space, -rightInset)];
  }
}

- (void)dw_resetEdgeInsets
{
  [self setContentEdgeInsets:UIEdgeInsetsZero];
  [self setImageEdgeInsets:UIEdgeInsetsZero];
  [self setTitleEdgeInsets:UIEdgeInsetsZero];
}


- (void)setEnlargeEdge:(CGFloat)size{
  objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left{
  objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect{
  
  NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
  NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
  NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
  NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
  if (topEdge && rightEdge && bottomEdge && leftEdge){
    return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                      self.bounds.origin.y - topEdge.floatValue,
                      self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                      self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
  }else{
    return self.bounds;
  }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
  CGRect rect = [self enlargedRect];
  if (CGRectEqualToRect(rect, self.bounds))
  {
    return [super pointInside:point withEvent:event];
  }
  return CGRectContainsPoint(rect, point) ? YES : NO;
}




@end
