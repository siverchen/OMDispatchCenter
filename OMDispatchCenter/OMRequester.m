//
//  OMRequester.m
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "OMRequester.h"
#import "OMSong.h"
#import "JSONKit.h"
#import "OMRequestHelper.h"
#import "NSString+More.h"
#import <ASIHTTPRequest/ASIFormDataRequest.h>


@implementation OMRequester

int num1 = 0;


- (void)requestAudioUrl:(OMSong *)song WithBlock:(FinishedGetUrl)block{
    
    __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/url/%@/%@/%@", [[OMRequestHelper shareHelper] getValueForKey:@"api_url_prefix"],1001, [[OMRequestHelper shareHelper] getValueForKey:@"audio_type"], [[OMRequestHelper shareHelper] getValueForKey:@"audio_effects_middle"], song.songid]]];
    [request addPostValue:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
    [request addPostValue:[[NSString stringWithFormat:@"%@%@%@%ld%@",song.songid, [[OMRequestHelper shareHelper] getValueForKey:@"audio_type"], [[OMRequestHelper shareHelper] getValueForKey:@"audio_effects_middle"],(long)[[NSDate date] timeIntervalSince1970], [[OMRequestHelper shareHelper] getValueForKey:@"audio_c"]] md5] forKey:@"cid"];
    [request setUserInfo:[NSDictionary dictionaryWithObject:song.songid forKey:@"song"]];
    
    [request setCompletionBlock:^{
        NSArray *resultArray = [[request.responseString objectFromJSONString] objectForKey:@"190"];
        NSURL *resultUrl = nil;
        for (NSDictionary *dict in resultArray){
            if ([[dict objectForKey:@"pname"] isEqual:@"url"]){
                resultUrl = [NSURL URLWithString:[dict objectForKey:@"pvalue"]];
                break;
            }
        }
        if (resultUrl){
            block(resultUrl);
        }else{
        }
        [request release];
    }];
    
    [request startAsynchronous];
}

@end
