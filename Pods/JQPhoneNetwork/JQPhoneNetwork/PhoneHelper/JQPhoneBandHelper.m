//
//  JQPhoneBandHelper.m
//  LsddHappyProject
//
//  Created by administrator on 2018/4/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JQPhoneBandHelper.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "UIApplication+MS.h"

#define kChinaMobileServiceName  @"中国移动"
#define kChinaUnicomServiceName  @"中国联通"
#define kChinaTelcomServiceName  @"中国电信"

@implementation JQPhoneBandHelper

+ (NSString *)getCarriorName
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrierName = carrier.carrierName;
    
    if (!([carrierName isEqualToString:kChinaMobileServiceName] || [carrierName isEqualToString:kChinaUnicomServiceName] || [carrierName isEqualToString:kChinaTelcomServiceName])) {
        NSString *carrierBarName = [UIApplication serviceNameFromStatusBar];
        if ([carrierBarName rangeOfString:kChinaMobileServiceName].length) {
            carrierName = kChinaMobileServiceName;
        } else if ([carrierBarName rangeOfString:kChinaUnicomServiceName].length) {
            carrierName = kChinaUnicomServiceName;
        } else if ([carrierBarName rangeOfString:kChinaTelcomServiceName].length) {
            carrierName = kChinaTelcomServiceName;
        }
    }
    return carrierName;
}

+ (PhoneBandType)getCarriorType
{
    PhoneBandType type = PhoneBandUnKnow;
    NSString *carrierName = [self getCarriorName];
    
    //carrierName=@"中国电信";
    if ([carrierName isEqualToString:kChinaMobileServiceName]) {
        type = PhoneBandYiDong;
    } else if ([carrierName isEqualToString:kChinaUnicomServiceName]) {
        type = PhoneBandLianTong;
    } else if ([carrierName isEqualToString:kChinaTelcomServiceName]) {
        type = PhoneBandDianXin;
    }
    return type;
}

+ (NSString *)getImsi
{
    PhoneBandType type = [self getCarriorType];
    NSString *imsi;
    if (type == PhoneBandUnKnow) {
        imsi = @"00000";
        //imsi = @"46000";//模拟移动
        //imsi = @"46001";//模拟联通
        //imsi = @"46003";//模拟电信
    } else if (type == PhoneBandYiDong) {
        imsi = @"46000";
    } else if (type == PhoneBandLianTong) {
        imsi = @"46001";
    } else if (type == PhoneBandDianXin) {
        imsi = @"46003";
    }
    return imsi;
}

@end
