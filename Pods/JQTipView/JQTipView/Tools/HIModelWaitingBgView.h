//
//  HIModelWaitingBgView.h
//
//  Created by Hari on 15-3-12.
//  Copyright (c) 2018年 Hari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIModelWaitingBgView : UIView
{
@private
    UIView *_foregroundView;
}

@property (nonatomic, assign) BOOL supportBlurBackground;

- (void)setToolBarStyle:(UIBarStyle)style;
- (void)setToolBarBackgroundColor:(UIColor *)color;
- (void)setForegroundViewColor:(UIColor *)color;

@end
