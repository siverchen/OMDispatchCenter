//
//  OMDownloader.m
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "OMDownloader.h"
#import "OMSong.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>

#define SONGTMPDIR(a)     [NSTemporaryDirectory() stringByAppendingFormat:@"Song/%@.tmp",a]
#define SONGDIR(a)      [NSTemporaryDirectory() stringByAppendingFormat:@"Song/%@.mp3",a]

NSString * const OMDownloaderAdd = @"OMDownloaderAdd";
NSString * const OMDownloaderWaiting = @"OMDownloaderWaiting";
NSString * const OMDownloaderStart = @"OMDownloaderStart";
NSString * const OMDownloaderPause = @"OMDownloaderPause";
NSString * const OMDownloaderRemove = @"OMDownloaderRemove";
NSString * const OMDownloaderFinished = @"OMDownloaderFinished";
NSString * const OMDownloaderProgress = @"OMDownloaderProgress";
NSString * const OMDownloaderError = @"OMDownloaderError";

@interface OMDownloader () <ASIHTTPRequestDelegate> {
    NSMutableArray *_songs;
    OMDownloadSongState state[2000];
    NSOperationQueue *_queue;
    NSString *_tmpPath;
    NSString *_desPath;
}

@end

@implementation OMDownloader

- (id)init{
    if (self = [super init]){
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingFormat:@"Song"]]){
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingFormat:@"Song"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

/*初始化下载歌曲*/
- (id)initWithSongs:(NSArray *)songs{
    if (self = [self init]){
        _songs = [[NSMutableArray alloc] initWithArray:songs];
        for (int i = 0; i < [_songs count]; i++){
            OMSong *song = [_songs objectAtIndex:i];
            if ([[NSFileManager defaultManager] fileExistsAtPath:SONGDIR(song.songid)]){
                state[i] = OMDownloadSongStateDownloaded;
            }else{
                state[i] = OMDownloadSongStatePause;
            }
        }
    }
    return self;
}


/*设定下载目录*/
- (void)setDownloadTmpPath:(NSString *)tmpPath
                   DesPath:(NSString *)desPath{
    _tmpPath = [tmpPath retain];
    _desPath = [desPath retain];
}

/* 获取未完成的歌曲 */
- (NSArray *)UncompletedSongs{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [_songs count]; i++){
        if (state[i] != OMDownloadSongStateDownloaded){
            [array addObject:[_songs objectAtIndex:i]];
        }
    }
    return array;
}

/* 获取完成的歌曲 */
- (NSArray *)completeSongs{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [_songs count]; i++){
        if (state[i] == OMDownloadSongStateDownloaded){
            [array addObject:[_songs objectAtIndex:i]];
        }
    }
    return array;
}

/* 判断是否已经下载 */
- (OMDownloadSongState)isDownloaded:(OMSong *)song{
    for (OMSong *asong in _songs){
        if ([asong isEqualSong:song]){
            return state[[_songs indexOfObject:asong]];
        }
    }
    return OMDownloadSongStateNone;
}

/*歌曲下载状态管理 */
- (void)resetState:(NSString *)songid State:(OMDownloadSongState)astate{
    for (int i = [_songs count] - 1; i >= 0; i--){
        OMSong *song = [_songs objectAtIndex:i];
        if ([song.songid isEqualToString:songid]){
            state[i] = astate;
            break;
        }
    }
}

/*加入新歌曲*/
- (OMDownloadSongState)addSong:(OMSong *)song{
    OMDownloadSongState dstate = [self isDownloaded:song];
    if (OMDownloadSongStateNone == dstate){
        [_songs addObject:song];
    }
    if (OMDownloadSongStateNone == dstate ||
        OMDownloadSongStatePause == dstate){
        [self resetState:song.songid
                   State:OMDownloadSongStateWaiting];
    }
    return dstate;
}

/* 开始下载歌曲 */
- (void)startSong:(OMSong *)song
          withUrl:(NSURL *)url{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDownloadProgressDelegate:self];
    [request setAllowResumeForFileDownloads:YES];
    [request setTemporaryFileDownloadPath:SONGTMPDIR(song.songid)];
    [request setDownloadDestinationPath:SONGDIR(song.songid)];
    [request setDelegate:self];
    [request setStartedBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OMDownloaderStart
                                                            object:song];
        [self resetState:song.songid
                   State:OMDownloadSongStateDownloading];
    }];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        [[NSNotificationCenter defaultCenter] postNotificationName:OMDownloaderProgress
                                                            object:song
                                                          userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:(double)(request.totalBytesRead + total - request.contentLength) / total] forKey:@"Progress"]];
    }];
    [request setFailedBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OMDownloaderError
                                                            object:song];
    }];
    [request setCompletionBlock:^{
        [self resetState:song.songid State:OMDownloadSongStateDownloaded];
        [[NSNotificationCenter defaultCenter] postNotificationName:OMDownloaderFinished
                                                            object:song];
    }];
    request.userInfo = [NSDictionary dictionaryWithObject:song
                                                   forKey:@"Song"];
    [[NSNotificationCenter defaultCenter] postNotificationName:OMDownloaderWaiting
                                                        object:song];
    [_queue addOperation:request];
    [request release];
}

/*停止下载*/
- (void)stopSong:(OMSong *)song{
    for (ASIHTTPRequest *request in [_queue operations]){
        if ([[[[request userInfo] objectForKey:@"Song"] songid] isEqualToString:song.songid]){
            [[NSNotificationCenter defaultCenter] postNotificationName:OMDownloaderPause object:song];
            [request clearDelegatesAndCancel];
        }
    }
}

/*移除下载*/

- (void)removeSong:(OMSong *)song{
    [self stopSong:song];
    [[NSFileManager defaultManager] removeItemAtPath:SONGDIR(song.songid) error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:SONGTMPDIR(song.songid) error:nil];
}

@end
