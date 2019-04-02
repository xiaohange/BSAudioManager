//
//  LsddHappyProject
//
//  Created by administrator on 2018/4/2.
//  Copyright © 2018年 administrator. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

static NSString *kNetStatusChangeNotification = @"kNetStatusChangeNotification";//最终变化通知以此为准

typedef enum {
    NetWorkUnknow,
    NetWorkNoConnect,
    NetWorkWifi,
    NetWork3G,
    NetWork2G,
    NetWork4G,
}NetWorkType;

typedef void (^bgNetworkHandle)(BOOL NetworkNormal);

@interface JQNetworkListener : NSObject

@property (nonatomic, strong) Reachability *internetReach;

+ (id)shareInstance;

- (void)startNotifier;
- (void)stopNotifier;
- (NetWorkType)currentNetWorkType;
- (BOOL)isNetConnect;
- (BOOL)isNetUnknown;
- (BOOL)isWifiNetWork;

/**
 检查网络状态
 
 @param networkReady networkReady description
 */
- (void)checkNetwork:(bgNetworkHandle)networkReady;

@end
