//
//  BSMusicModel.h
//  DouAudioStreamDemo
//
//  Created by DuoLa on 2019/3/30.
//  Copyright © 2019 DuoLa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSMusicModel : NSObject
/**
 * 名称
 */
@property (nonatomic, copy) NSString* name;
/**
 * 作者
 */
@property (nonatomic, copy) NSString* author;
/**
 * 试听url
 */
@property (nonatomic, copy) NSString* play_url;
@end

NS_ASSUME_NONNULL_END
