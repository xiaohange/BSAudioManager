//
//  LsddHappyProject
//
//  Created by administrator on 2018/4/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JQNetworkListener.h"
#import "UIApplication+MS.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation JQNetworkListener

static JQNetworkListener *__netListener = nil;

- (void)reachabilityChanged:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetStatusChangeNotification object:nil];
    });
}

- (Reachability *)internetReach
{
    if (!_internetReach) {
        _internetReach = [[Reachability reachabilityForInternetConnection] retain];
    }
    return _internetReach;
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
}

- (void)resignNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

+ (id)shareInstance
{
    if (!__netListener) {
        __netListener = [[JQNetworkListener alloc] init];
        [__netListener startNotifier];
    }
    return __netListener;
}

- (id)init
{
    if (self = [super init]) {
        [self registerNotification];
    }
    return self;
}

- (void)dealloc
{
    [self resignNotification];
    [_internetReach stopNotifier];
    [_internetReach release];
    [super dealloc];
}

#pragma mark 外部调用

- (void)startNotifier
{
    [[self internetReach] startNotifier];
}

- (void)stopNotifier
{
    if (_internetReach)
    {
        [_internetReach stopNotifier];
    }
}

- (NetworkStatus)currentNetWorkStatus
{
    return [[self internetReach] currentReachabilityStatus];
}

- (NetWorkType)currentNetWorkType{
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    NetworkStatus state = [self currentNetWorkStatus];
    if (state == ReachableViaWiFi){
        return NetWorkWifi;
    }else if (state == ReachableViaWWAN){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
            NSString *accessString = teleInfo.currentRadioAccessTechnology;
            if ([typeStrings4G containsObject:accessString]) {
                return NetWork4G;
            } else if ([typeStrings3G containsObject:accessString]) {
                NSLog(@"3G网络");
            } else if ([typeStrings2G containsObject:accessString]) {
                return NetWork3G;
            } else {
                return NetWork2G;
            }
        } else {
            return NetWorkUnknow;
        }
        return NetWorkUnknow;
    }
    return NetWorkNoConnect;
}

- (BOOL)isNetConnect
{
    return [self currentNetWorkType] != NetWorkNoConnect;
}

- (BOOL)isNetUnknown
{
    return [self currentNetWorkType] == NetWorkUnknow;
}

- (BOOL)isWifiNetWork
{
    return [self currentNetWorkType] == NetWorkWifi;
}

- (void)checkNetwork:(bgNetworkHandle)networkReady
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusNotReachable) {
            //网络不可用
            if (networkReady) {
                networkReady(NO);
            }
        } else {
            if (networkReady) {
                networkReady(YES);
            }
        }
    }];
    [manager startMonitoring];
}

@end
