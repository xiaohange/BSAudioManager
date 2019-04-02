//
//  NSString+HIExtern.m
//  BellSjlsProject
//
//  Created by administrator on 2018/5/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "NSString+HIExtern.h"

@implementation NSString (JQExtern)

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString
{
    return [self compare:aString options:NSCaseInsensitiveSearch] == 0;
}

@end
