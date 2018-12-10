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
    return CGRectInset(bounds, 20, 4);
}

//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    
    return CGRectInset(bounds,0,0);
}

//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 20, 0);
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 20, 0);
}


@end
