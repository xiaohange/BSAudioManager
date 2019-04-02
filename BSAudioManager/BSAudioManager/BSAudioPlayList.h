//
//  BSAudioPlayList.h
//  MusicRing
//
//  Created by David on 16/3/29.
//  Copyright © 2016年 BlueSky. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BSAudioPlayList : NSObject
{
@private
    NSArray *_audioPlayItemList;
}

+ (instancetype)audioPlayListWithList:(NSArray *)audioPlayList;
+ (instancetype)audioPlayListWithList:(NSArray *)audioPlayList currentPlayIndex:(NSInteger)playIndex;

@property (nonatomic, readwrite, assign) NSInteger currentPlayIndex;
@property (nonatomic, readonly) id currentPlayAudioItem;
@property (nonatomic, readonly) NSInteger playAudioItemCount;

- (id)getAudioItemAtIndex:(NSInteger)index;

@end
