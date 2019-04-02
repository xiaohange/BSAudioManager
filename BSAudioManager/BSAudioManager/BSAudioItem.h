//
//  BSAudioItem.h
//  MusicRing
//
//  Created by David on 15-7-28.
//  Copyright (c) 2015年 BlueSky. All rights reserved.

#import <Foundation/Foundation.h>
#import "BSMusicModel.h"
#import "DOUAudioStreamer.h"

@interface BSAudioItem : NSObject <DOUAudioFile>
{
    NSString *_fileName;
    NSURL *_audioURL;
}

@property (nonatomic, readonly) NSURL *audioUrl;
@property (nonatomic, strong)   BSMusicModel* originAudioItem;

+ (instancetype)audioItemWithAudioUrl:(NSURL *)audioUrl;
+ (instancetype)audioItemWithOriginAudioDataItem:(BSMusicModel*)item;


- (NSString *)audioCachePath;

- (NSString *)audioName;
- (NSString *)authorName;


- (NSURL *)audioUrl;

- (NSString *)cachePath;

@end
