/* vim: set ft=objc fenc=utf-8 sw=2 ts=2 et: */
/*
 *  DOUAudioStreamer - A Core Audio based streaming audio player for iOS/Mac:
 *
 *      https://github.com/douban/DOUAudioStreamer
 *
 *  Copyright 2013 Douban Inc.  All rights reserved.
 *
 *  Use and distribution licensed under the BSD license.  See
 *  the LICENSE file for full text.
 *
 *  Authors:
 *      Chongyu Zhu <lembacon@gmail.com>
 *
 */

#import <Foundation/Foundation.h>

#define kDOUAudioAnalyzerLevelCount 20

@interface DOUAudioAnalyzer : NSObject

+ (instancetype)analyzer;

- (void)handleLPCMSamples:(int16_t *)samples count:(NSUInteger)count;
- (void)flush;

- (void)copyLevels:(float *)levels;

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
