//
//  NSString+More.h
//  OMPlayer
//
//  Created by Chen Lei on 12-10-18.
//  Copyright (c) 2012年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (More)

- (NSString *) md5;
- (void)ParseLyric:(NSMutableArray **)lyricObject andOutputLyricStamp:(NSMutableArray **)stamp;

+ (NSString *) base64StringFromString:(NSString *)string;

+ (NSString *)sha1:(NSString *)str;


- (NSString *)verifyUsername;
- (NSString *)verifyPassword;

@end
