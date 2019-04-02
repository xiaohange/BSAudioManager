//
//  BSAudioPlayModelManager.m
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioPlayModelManager.h"
#import "BSAudioPlayModel.h"

@implementation BSAudioPlayModelManager

#pragma mark -

- (BSAudioPlayModel *)currentPlayModel
{
    return [_playModelDictionary objectForKey:[NSNumber numberWithInteger:_currentModelType]];
}

#pragma mark -

- (void)initModelDictionary
{
    _currentModelType = BSAudioPlayModelOrderedType;
    _playModelDictionary = [NSMutableDictionary dictionary];
    [_playModelDictionary setObject:[BSAudioPlayModel audioPlayModelWithType:BSAudioPlayModelOrderedType] forKey:[NSNumber numberWithInteger:BSAudioPlayModelOrderedType]];
    [_playModelDictionary setObject:[BSAudioPlayModel audioPlayModelWithType:BSAudioPlayModelCircleType] forKey:[NSNumber numberWithInteger:BSAudioPlayModelCircleType]];
}

- (id)init
{
    if (self = [super init]) {
        _enable = YES;
        [self initModelDictionary];
    }
    return self;
}

#pragma mark -

- (BSAudioPlayList *)audioPlayList
{
    return [[self currentPlayModel] audioPlayList];
}

- (void)setAudioPlayList:(BSAudioPlayList *)audioPlayList
{
    [self currentPlayModel].audioPlayList = audioPlayList;
}

- (NSInteger)currentPlayIndex
{
    return [[self currentPlayModel] currentPlayIndex];
}

- (id)currentPlayAudioItem
{
    return [[self currentPlayModel] currentPlayAudioItem];
}

#pragma mark -

- (void)changeToNextPlayAudioItem
{
    [[self currentPlayModel] changeToNextPlayAudioItem];
}

- (void)changeToPreviousPlayAudioItem
{
    [[self currentPlayModel] changeToPreviousPlayAudioItem];
}


@end
