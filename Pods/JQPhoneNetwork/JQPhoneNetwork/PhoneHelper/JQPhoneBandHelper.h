//
//  JQPhoneBandHelper.h
//  LsddHappyProject
//
//  Created by administrator on 2018/4/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PhoneBandType) {
    PhoneBandUnKnow = 0,
    PhoneBandYiDong,
    PhoneBandLianTong,
    PhoneBandDianXin,
};

@interface JQPhoneBandHelper : NSObject

+ (PhoneBandType)getCarriorType;

+ (NSString *)getImsi;

@end
