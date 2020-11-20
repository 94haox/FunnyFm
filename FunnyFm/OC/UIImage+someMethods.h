//
//  UIImage+someMethods.h
//  testImage
//
//  Created by 吴涛 on 16/3/1.
//  Copyright © 2016年 Duke.Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (someMethods)

- (UIColor *)mostColor;

+ (UIImage *)qrCodeImageEncoderWithStr:(NSString *)urlStr
                             imageSize:(CGFloat)size;

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                            withSize:(CGFloat) size;

- (UIImage *)roundRectImageWithCornerRadius:(CGFloat)radius;

@end
