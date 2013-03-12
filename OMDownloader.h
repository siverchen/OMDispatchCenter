//
//  OMDownloader.h
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMSong;

typedef enum {
	OMDownloadSongStateDownloaded = 0,
	OMDownloadSongStateDownloading,
    OMDownloadSongStateWaiting,
    OMDownloadSongStatePause,
    OMDownloadSongStateNone
}OMDownloadSongState;

extern NSString * const OMDownloaderAdd;
extern NSString * const OMDownloaderWaiting;
extern NSString * const OMDownloaderStart;
extern NSString * const OMDownloaderPause;
extern NSString * const OMDownloaderRemove;
extern NSString * const OMDownloaderFinished;
extern NSString * const OMDownloaderProgress;
extern NSString * const OMDownloaderError;


@interface OMDownloader : NSObject


- (OMDownloadSongState)addSong:(OMSong *)song;

- (void)startSong:(OMSong *)song
          withUrl:(NSURL *)url;

- (void)stopSong:(OMSong *)song;

- (void)removeSong:(OMSong *)song;

- (void)setDownloadTmpPath:(NSString *)tmpPath
                   DesPath:(NSString *)desPath;


- (NSArray *)UncompletedSongs;

- (NSArray *)completeSongs;


@end
