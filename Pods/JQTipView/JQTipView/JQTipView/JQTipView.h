//
//  JQTipView.h
//  JQTipViewDemo
//  Created by Hari on 15-9-27.
//  Copyright (c) 2018 年 Hari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIModelWaitingBgView.h"

@interface JQTipView : UIWindow
{
@private
    HIModelWaitingBgView *_bgView;
    UILabel *_label;      
    NSTimer *_timer;
    BOOL _withKeyBoard;
}
@property (nonatomic, strong) id appdelegate;
- (id)initWithTip:(NSString *)tip withKeyBoard:(BOOL)withKeyBoard;
- (void)show;
- (NSString *)showtext;

+ (JQTipView *)showWithTip:(NSString *)tip;
+ (JQTipView *)showWithTip:(NSString *)tip withKeyBoard:(BOOL)withKeyBoard;
+ (void)releaseTipControlMgr;

@end
