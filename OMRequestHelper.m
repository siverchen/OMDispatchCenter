//
//  OMRequestHelper.m
//  OMusic
//
//  Created by siver on 12-12-13.
//  Copyright (c) 2012年 OceanMusic. All rights reserved.
//

#import "OMRequestHelper.h"
#import <MediaPlayer/MediaPlayer.h>

#define VERSION 1001

static OMRequestHelper *helper;

@implementation OMRequestHelper

+ (OMRequestHelper *)shareHelper{
    if (helper == nil){
        helper = [[OMRequestHelper alloc] init];
    }
    return helper;
}

- (id)init{
    if (self = [super init]){
        
        // 读取请求配置文件
        inforequests = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"inforequests" ofType:@"plist"]];
        // 读取图片请求的配置文件
        imagerequests = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imagerequests" ofType:@"plist"]];
        // 读取vc请求的配置文件
        vcrequests = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vcrequests" ofType:@"plist"]];
        //读取全局变量
        if (![[NSFileManager defaultManager] fileExistsAtPath:INFOMAPDIR]){
            [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"infomap" ofType:@"plist"] toPath:INFOMAPDIR error:nil];
        }
        infomap = [[NSArray alloc] initWithContentsOfFile:INFOMAPDIR];
        
    }
    return self;
}

- (NSString *)getValueForKey:(NSString *)key{
    for (NSDictionary *dict in infomap){
        if ([[dict objectForKey:@"pname"] isEqualToString:key]){
            return [dict objectForKey:@"pvalue"];
        }
    }
    return nil;
}

/*生成常规request的URL*/
- (NSURL *)generateUrl:(NSString *)vcname number:(int)number sid:(NSString *)sid start:(int)start length:(int)length{
    NSArray *vr = [vcrequests objectForKey:vcname];
    NSDictionary *myvr = [vr objectAtIndex:number];
    NSString *mode = [myvr objectForKey:@"mode"];
    NSString *type = [myvr objectForKey:@"type"];
    NSString *a = [myvr objectForKey:@"a"];
    NSString *b = [myvr objectForKey:@"b"];
    int alength = [myvr objectForKey:@"length"] ? [[myvr objectForKey:@"length"] intValue] : length;
    if ([mode rangeOfString:@"info"].location != NSNotFound){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/%@/%@/%@",[self getValueForKey:@"api_url_prefix"],VERSION, mode, type, sid]];
    }else if([mode rangeOfString:@"list"].location != NSNotFound){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/%@/%@/%@/%d/%d",[self getValueForKey:@"api_url_prefix"], VERSION, mode, type, sid, start, alength]];
    }else if ([mode isEqual:@"search"]){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/%@/%@/00/%d/%d",[self getValueForKey:@"api_url_prefix"], VERSION, mode, type, start, alength]];
    }else if ([mode isEqualToString:@"cmd"]){
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/%@/%@/%@/%@/%@",[self getValueForKey:@"api_url_prefix"], VERSION, mode, type, sid, a, b]];
    }
    return nil;
}




/*生成图片url*/

- (NSURL *)generateImageUrl:(ImageRequestType)type Sid:(NSString *)sid{
    NSDictionary *config = [imagerequests objectAtIndex:type];
    NSString *mode = [config objectForKey:@"type"];
    NSString *prefix = [self getValueForKey:[config objectForKey:@"prefix"]];
    NSString *size = [self getValueForKey:[config objectForKey:@"size"]];
    NSString *suf = [self getValueForKey:[config objectForKey:@"suffix"]];
    
    NSString *urlstr = nil;
    if ([mode isEqualToString:@"album"]){
        NSString *mod1 = [self getValueForKey:[config objectForKey:@"mod1"]];
        NSString *mod2 = [self getValueForKey:[config objectForKey:@"mod2"]];
        int mod01 = (int)floor(([sid intValue]%[mod1 intValue])/[mod2 floatValue]);
        int mod02 = [sid intValue] % [mod1 intValue] % [mod2 intValue];
        urlstr = [NSString stringWithFormat:@"%@%d/%d/%@%@%@", prefix, mod01, mod02, sid, size, suf];
    }else if ([mode isEqualToString:@"artist"]){
        NSString *mod = [self getValueForKey:[config objectForKey:@"mod"]];
        urlstr = [NSString stringWithFormat:@"%@%d/%@%@%@", prefix, [sid intValue] % [mod intValue], sid, size, suf];
    }else if ([mode isEqualToString:@"songlist"]){
        NSString *mod = [self getValueForKey:[config objectForKey:@"mod"]];
        urlstr = [NSString stringWithFormat:@"%@%d/%@%@%@", prefix, [sid intValue] % [mod intValue], sid, size, suf];
    }else if ([mode isEqualToString:@"radio"]){
        urlstr = [NSString stringWithFormat:@"%@%@%@%@",prefix,sid, size, suf];
    }
    return [NSURL URLWithString:urlstr];
}



@end
