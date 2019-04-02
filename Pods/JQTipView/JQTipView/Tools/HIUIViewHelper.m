//
//  HIUIViewHelper.m
//  JQTipViewDemo
//
//  Created by Hari on 15-5-22.
//  Copyright (c) 2018 年 Hari. All rights reserved.
//

#import "HIUIViewHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation HIUIViewHelper

+ (UIButton *)createBtnWithFrame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.exclusiveTouch = YES;
    return btn;
}

+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title
{
    UIButton *btn = [HIUIViewHelper createBtnWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)createButton:(CGFloat)x 
                      theY:(CGFloat)y 
        theNormalImageName:(NSString *) normalImageName 
       thePressedImageName:(NSString *) pressedImageName 

{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    
    UIImage *buttonImageNomal = [UIImage imageNamed:normalImageName];
    UIImage *buttonImagePressed =  [UIImage imageNamed:pressedImageName];
    [button setImage:buttonImageNomal forState:UIControlStateNormal];
    [button setImage:buttonImagePressed forState:UIControlStateHighlighted];
    button.frame = CGRectMake(x,y,buttonImageNomal.size.width,buttonImageNomal.size.height);
    return button;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame 
                    textAlignment:(NSTextAlignment)textAlignment 
                             font:(UIFont *)font 
                        textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = textAlignment;
    if (font) 
    {
        label.font = font;
    }
    if (textColor) 
    {
        label.textColor = textColor;
    }
    label.backgroundColor = [UIColor clearColor];
    return label ;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = frame;
    return imageView;
}

// 对视图进行圆角处理
+ (void)roundView:(UIView *)view radius:(CGFloat)radius
{
    if (!view) 
    {
        return;
    }
    CALayer *layer = view.layer;
    layer.cornerRadius = radius;
}


@end
