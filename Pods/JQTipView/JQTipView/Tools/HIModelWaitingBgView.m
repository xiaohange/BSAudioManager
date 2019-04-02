//
//  HIModelWaitingBgView.m
//  JQTipViewDemo
//
//  Created by Hari on 15-3-12.
//  Copyright (c) 2018年 Hari. All rights reserved.
//

#import "HIModelWaitingBgView.h"

@interface HIModelWaitingBgView ()
{
    UIToolbar *_toolBar;
}

@end

@implementation HIModelWaitingBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _supportBlurBackground = YES;
        _toolBar = [[UIToolbar alloc] initWithFrame:self.bounds];
        _toolBar.barStyle = UIBarStyleBlack;
        [self addSubview:_toolBar];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetChildViewFrame];
}

- (void)resetChildViewFrame
{
    _foregroundView.frame = self.bounds;
    _toolBar.frame = self.bounds;
}

- (void)setSupportBlurBackground:(BOOL)supportBlurBackground
{
    if (supportBlurBackground == _supportBlurBackground) {
        return;
    }
    _supportBlurBackground = supportBlurBackground;
    if (_supportBlurBackground) {
        [_foregroundView removeFromSuperview];
        _foregroundView = nil;
        if (!_toolBar) {
            _toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
            _toolBar.barStyle = UIBarStyleBlack;
            [self addSubview:_toolBar];
        }
    } else {
        [_toolBar removeFromSuperview];
        _toolBar = nil;
        if (!_foregroundView) {
            _foregroundView = [[UIView alloc] initWithFrame:self.bounds];
            [self addSubview:_foregroundView];
            _foregroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        }
    }
    [self resetChildViewFrame];
}

- (void)setToolBarStyle:(UIBarStyle)style
{
    _toolBar.barStyle = style;
}

- (void)setToolBarBackgroundColor:(UIColor *)color
{
    _toolBar.barTintColor = color;
}

- (void)setForegroundViewColor:(UIColor *)color
{
    _foregroundView.backgroundColor = color;
}

@end

