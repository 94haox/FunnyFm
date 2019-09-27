//
//  UIButton+SomeMethods.h
//  MyDBang
//
//  Created by mac on 2017/8/10.
//  Copyright © 2017年 Ziteng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SomeMethods)

- (void)dw_titleImageHorizontalAlignmentWithSpace:(float)space;
- (void)dw_imageTitleHorizontalAlignmentWithSpace:(float)space;
- (void)dw_titleImageVerticalAlignmentWithSpace:(float)space;
- (void)dw_imageTitleVerticalAlignmentWithSpace:(float)space;
- (void)setEnlargeEdge:(CGFloat)size;

@end
