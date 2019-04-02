//
//  BSAudioPlayModel.m
//  MusicRing
//  音频播放模式
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioPlayModel.h"
#import "BSOrderAudioPlayModel.h"
#import "BSCircleAudioPlayModel.h"

@implementation BSAudioPlayModel

- (instancetype)initWithType:(BSAudioPlayModelType)modelType audioPlayList:(BSAudioPlayList *)playList
{
    if (self = [super init]) {
        _modelType = modelType;
        _audioPlayList = playList;
    }
    return self;
}

+ (instancetype)audioPlayModelWithType:(BSAudioPlayModelType)modelType
{
    return [[self class] audioPlayModelWithType:modelType audioPlayList:nil];
}


+ (instancetype)audioPlayModelWithType:(BSAudioPlayModelType)modelType audioPlayList:(BSAudioPlayList *)playList
{
    BSAudioPlayModel *playModel = nil;
    switch (modelType) {
        case BSAudioPlayModelOrderedType:
            playModel = [[BSOrderAudioPlayModel alloc] initWithType:modelType audioPlayList:playList];
            break;
        case BSAudioPlayModelCircleType:
            playModel = [[BSCircleAudioPlayModel alloc] initWithType:modelType audioPlayList:playList];
            break;
        default:
            break;
    }
    return playModel;
}

- (NSInteger)currentPlayIndex
{
    return _audioPlayList.currentPlayIndex;
}

- (id)currentPlayAudioItem
{
    return _audioPlayList.currentPlayAudioItem;
}

- (void)changeToNextPlayAudioItem
{
    
}

- (void)changeToPreviousPlayAudioItem
{
    
}

- (BOOL)hasNextPlayItem
{
    return NO;
}

- (BOOL)hasPreviousPlayItem
{
    return NO;
}

- (id)getNextPlayItem
{
    return nil;
}

- (id)getPreviousPlayItem
{
    return nil;
}


@end
