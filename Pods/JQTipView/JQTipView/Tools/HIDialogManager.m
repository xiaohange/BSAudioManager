//
//  HIDialogManager.m
//  JQTipViewDemo
//
//  Created by Hari on 2017/5/11.
//  Copyright © 2017年 Hari. All rights reserved.
//

#import "HIDialogManager.h"

@implementation HIDialogManager
{
    BOOL _setRingClicked;
}

+ (instancetype)shareManager
{
    static HIDialogManager *_sharedMiguManger = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedMiguManger = [[HIDialogManager alloc] init];
    });
    return _sharedMiguManger;
}

- (BOOL)canIShow
{
    BOOL show = !self.adDialogState && !self.auditionVipDialogState && !self.orderDialogState && !self.scoreDialogState;
    if (show) {
        return YES;
    }
    return NO;
}

- (void)updateRingClickState:(BOOL)state
{
    _setRingClicked = state;
}

- (BOOL)isClickSetRing
{
    return _setRingClicked;
}


- (BOOL)canIShowTip
{
    return !_showTipState;
}


@end
