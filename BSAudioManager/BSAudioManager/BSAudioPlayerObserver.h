//
//  BSAudioPlayerObserver.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BSAudioPlayerHelper.h"

@protocol BSAudioPlayerHelperProtocol <NSObject>

- (void)audioPlayerHelperDidLaunch; //开始
- (void)audioPlayerHelperInPlaying; //播放
- (void)audioPlayerHelperInBuffering;//缓冲
- (void)audioPlayerHelperInPause;//暂停
- (void)audioPlayerHelperFinish;//播放完成
- (void)audioPlayerHelperUserStop;//用户停止
- (void)audioPlayerHelperOccurError:(NSError *)error;//播放遇到错误
- (void)audioPlayerHelperUpdateWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration; //更新进度和时长
- (void)audioPlayerHelperChange;//改变

@optional

- (void)playNextAudioItem; //播放下一个音频
- (void)playPreviousAudioItem;//播放前一个音频
- (void)playOrPause;//播放或暂停
- (void)resume;//恢复
- (void)stop;//停止

@end

@interface BSAudioPlayerObserver : NSObject

#pragma mark -

+ (instancetype)defaultAudioPlayerObserver;

#pragma mark -

@property (nonatomic, weak) id<BSAudioPlayerHelperProtocol> currentAudioPlayerHelper;

- (void)remoteControlReceivedWithEvent:(UIEvent *)event;

@end
