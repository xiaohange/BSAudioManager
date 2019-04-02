//
//  UIApplication+MS.m

//  Created by Nicolas Seriot on 7/9/12.
//  Copyright (c) 2012 administrator. All rights reserved.
//

#import "UIApplication+MS.h"
#import <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@class UIStatusBarForegroundView;
@class UIStatusBarServiceItemView;

@implementation UIApplication (MS)


+ (NSString *)serviceNameFromStatusBar{
    //获取本机运营商名称
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        mobile = @"无运营商";
    }else{
        mobile = [carrier carrierName];
    }
    return mobile;
}

@end
