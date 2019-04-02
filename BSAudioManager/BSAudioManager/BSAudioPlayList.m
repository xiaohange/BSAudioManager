//
//  BSAudioPlayList.m
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import "BSAudioPlayList.h"

@implementation BSAudioPlayList

#pragma mark -

- (id)initWithAudioPlayList:(NSArray *)audioPlayList currentPlayIndex:(NSInteger)playIndex
{
    if (self = [super init]) {
        _audioPlayItemList = audioPlayList;
        _currentPlayIndex = playIndex;
    }
    return self;
}

+ (instancetype)audioPlayListWithList:(NSArray *)audioPlayList
{
    return [[self class] audioPlayListWithList:audioPlayList currentPlayIndex:0];
}

+ (instancetype)audioPlayListWithList:(NSArray *)audioPlayList currentPlayIndex:(NSInteger)playIndex
{
    return [[[self class] alloc] initWithAudioPlayList:audioPlayList currentPlayIndex:playIndex];
}

#pragma mark -

- (id)currentPlayAudioItem
{
    return [_audioPlayItemList objectAtIndex:_currentPlayIndex];
}

- (NSInteger)playAudioItemCount
{
    return _audioPlayItemList.count;
}

- (void)setCurrentPlayIndex:(NSInteger)currentPlayIndex
{
    if (currentPlayIndex < 0) {
        _currentPlayIndex = 0;
    }
    else if (_currentPlayIndex >= _audioPlayItemList.count) {
        _currentPlayIndex = _audioPlayItemList.count - 1;
    }
    _currentPlayIndex = currentPlayIndex;
}

- (id)getAudioItemAtIndex:(NSInteger)index
{
    return [_audioPlayItemList objectAtIndex:index];
}

@end
