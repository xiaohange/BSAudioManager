//
//  HIUIViewHelper.h
//  JQTipViewDemo
//
//  Created by Hari on 15-5-22.
//  Copyright (c) 2018 年 Hari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HIUIViewHelper : NSObject

+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title;
+ (UIButton *)createBtnWithFrame:(CGRect)frame;
+ (UIButton *)createButton:(CGFloat)x 
                      theY:(CGFloat)y 
        theNormalImageName:(NSString *) normalImageName 
       thePressedImageName:(NSString *) pressedImageName;
+ (UILabel *)createLabelWithFrame:(CGRect)frame 
                    textAlignment:(NSTextAlignment)textAlignment
                             font:(UIFont *)font 
                        textColor:(UIColor *)textColor;
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image;
+ (void)roundView:(UIView *)view radius:(CGFloat)radius;

@end
