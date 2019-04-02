//
//  BSAudioItem.m
//  MusicRing
//
//  Created by David on 15-7-28.
//  Copyright (c) 2015年 BlueSky. All rights reserved.

#import "BSAudioItem.h"
#import "CommonCrypto/CommonDigest.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation BSAudioItem

- (id)initWithOriginPlayDataItem:(BSMusicModel*)item
{
    if (self = [super init]) {
        self.originAudioItem = item;
        NSString *cachePath = [self cachePath];
        BOOL isDirectory = NO;
        BOOL isAudioCacheExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDirectory];
        if (isAudioCacheExist && !isDirectory) {
            _audioURL = [NSURL fileURLWithPath:cachePath];
        } else {
            _audioURL = [NSURL URLWithString:item.play_url];
        }
    }
    return self;
}


+ (instancetype)audioItemWithOriginAudioDataItem:(BSMusicModel*)item
{
    if (!item) {
        return nil;
    }
    return [[[self class] alloc] initWithOriginPlayDataItem:item];
}

- (NSURL *)audioUrl
{
    return _audioURL;
}

- (BSMusicModel*)originAudioItem
{
    return _originAudioItem;
}

- (NSString *)audioCachePath
{
//    if (!_fileName) {
//        NSURL* tmpUrl = [NSURL URLWithString:self.originAudioItem.play_url];
//        NSString *audioUrl = [tmpUrl absoluteString];
//        NSString *fileExtension = [audioUrl pathExtension];
//        _fileName = [self getMD5EncryptString:audioUrl];
//        if (fileExtension) {
//            _fileName = [_fileName stringByAppendingPathExtension:fileExtension];
//        }
//    }
//
//    return [[[LDFileHelper shareInstance] getMusicCacheDir] stringByAppendingPathComponent:_fileName];
    return nil;//此处暂时注释掉，如果需要自定义缓存路径或者指定音频后缀文件需要在此处处理
}

- (NSString *)getMD5EncryptString:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

#pragma mark DOUAudioFile

- (NSURL *)audioFileURL
{
    return _audioURL;
}

- (NSString *)cachePath
{
    return [self audioCachePath];
}

- (NSString *)audioName
{
    return self.originAudioItem.name;
}

- (NSString *)authorName
{
    return self.originAudioItem.author;
}

@end
