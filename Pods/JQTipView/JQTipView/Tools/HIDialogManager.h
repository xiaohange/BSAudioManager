//
//  HIDialogManager.h
//  JQTipViewDemo
//
//  Created by Hari on 2017/5/11.
//  Copyright © 2017年 Hari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIDialogManager : NSObject

@property (nonatomic, assign) BOOL adDialogState;
@property (nonatomic, assign) BOOL auditionVipDialogState;
@property (nonatomic, assign) BOOL scoreDialogState;
@property (nonatomic, assign) BOOL orderDialogState;
@property (nonatomic, assign) BOOL showTipState;

+ (instancetype)shareManager;
- (BOOL)canIShow;
- (BOOL)canIShowTip;
- (BOOL)isClickSetRing;
- (void)updateRingClickState:(BOOL)state;

@end
