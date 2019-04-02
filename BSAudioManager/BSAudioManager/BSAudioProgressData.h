//
//  BSAudioProgressData.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BSAudioPlayerDefines.h"
#import <UIKit/UIKit.h>

@interface BSAudioProgressData : NSObject <NSCopying>

@property (nonatomic, copy)   NSString *audioUrl;
@property (nonatomic, assign) BSAudioPlayerStatus status;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;

- (CGFloat)progress;
- (NSTimeInterval)lastPlayTime;
- (NSString *)getLastPlayTimeStr;

@end
