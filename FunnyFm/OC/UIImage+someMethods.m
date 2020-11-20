//
//  UIImage+someMethods.m
//  testImage
//
//  Created by 吴涛 on 16/3/1.
//  Copyright © 2016年 Duke.Wu. All rights reserved.
//

#import "UIImage+someMethods.h"

@implementation UIImage (someMethods)

-(UIColor *)mostColor{
  
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
  
  int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
  
#else
  
  int bitmapInfo = kCGImageAlphaPremultipliedLast;
  
#endif
  
  //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
  CGSize thumbSize = CGSizeMake(50, 50);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL,
                                               thumbSize.width,
                                               thumbSize.height,
                                               8,
                                               thumbSize.width*4,
                                               colorSpace,
                                               bitmapInfo);
  
  CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
  CGContextDrawImage(context, drawRect, self.CGImage);
  CGColorSpaceRelease(colorSpace);
  
  //第二步 取每个点的像素值
  unsigned char* data = CGBitmapContextGetData (context);
  
  if (data == NULL) return nil;
  
  NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
  
  for (int x = 0; x < thumbSize.width; x ++) {
    for (int y = 0; y < thumbSize.height; y ++) {
      
      int offset = 4 * (x * y);
      
      int red = data[offset];
      int green = data[offset+1];
      int blue = data[offset+2];
      int alpha =  data[offset+3];
      
      NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
      [cls addObject:clr];
      
    }
  }
  CGContextRelease(context);
  
  //第三步 找到出现次数最多的那个颜色
  NSEnumerator *enumerator = [cls objectEnumerator];
  NSArray *curColor = nil;
  
  NSArray *MaxColor = nil;
  NSUInteger MaxCount = 0;
  
  while ( (curColor = [enumerator nextObject]) != nil ) {
    
    NSUInteger tmpCount = [cls countForObject:curColor];
    
    if ( tmpCount < MaxCount ){
      continue;
    };
    
    MaxCount=tmpCount;
    MaxColor=curColor;
    
  }
  return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
  
}

+ (UIImage *)qrCodeImageEncoderWithStr:(NSString *)urlStr imageSize:(CGFloat)size {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    return [UIImage createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *scaleImage = [UIImage imageWithCGImage:scaledImage];
    CGContextRelease(bitmapRef);
    CGColorSpaceRelease(cs);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return scaleImage;
}

- (UIImage *)roundRectImageWithCornerRadius:(CGFloat)radius {
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:radius] addClip];
    [self drawInRect:imageRect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
