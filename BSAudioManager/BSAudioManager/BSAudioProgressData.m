//
//  BSAudioProgressData.m
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioProgressData.h"

@implementation BSAudioProgressData

#pragma mark -

- (id)copyWithZone:(NSZone *)zone
{
    BSAudioProgressData *data = [[BSAudioProgressData alloc] init];
    data.status = self.status;
    data.duration = self.duration;
    data.currentTime = self.currentTime;
    return data;
}

#pragma mark -

- (CGFloat)progress
{
    if (fabs(_duration) < 1e-6 || isnan(_duration) || isinf(_duration)) {
        return 0;
    }
    if (fabs(_currentTime) < 1e-6 || isnan(_currentTime) || isinf(_currentTime)) {
        return 0;
    }
    return _currentTime / _duration;
}

- (NSTimeInterval)lastPlayTime
{
    return _duration - _currentTime;
}

- (void)setStatus:(BSAudioPlayerStatus)status
{
    _status = status;
    if (_status == BSAudioPlayerLaunch || _status == BSAudioPlayerIdle) {
        _duration = 0;
        _currentTime = 0;
    }
}

- (NSString *)getLastPlayTimeStr
{
    return [self getTimeStringOfTime:_duration - _currentTime];
}

- (NSString *)getTimeStringOfTime:(NSTimeInterval)time
{
    if (time <= 60.0) {
        return [NSString stringWithFormat:@"%d:%02d", 0, (int)time];
    }
    else {
        return [NSString stringWithFormat:@"%02d:%02d",(int)time/60,(int)time%60];
    }
}

@end
