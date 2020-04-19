//
//  FMTextField.m
//  FunnyFm
//
//  Created by Duke on 2018/12/10.
//  Copyright © 2018 Duke. All rights reserved.
//

#import "FMTextField.h"

@interface FMTextField ()

@end


@implementation FMTextField


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 30, 4);
}

////控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{

    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 5; //像右边偏15
    return iconRect;
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 30, 0);
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 30, 0);
}


@end
