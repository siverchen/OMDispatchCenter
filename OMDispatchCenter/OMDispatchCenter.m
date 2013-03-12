//
//  OMDispatchCenter.m
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "OMDispatchCenter.h"
#import <OMDownloader/OMDownloader.h>
#import "OMDBController.h"
#import "OMSong.h"
#import "OMRequester.h"

@implementation OMDispatchCenter

- (void)dealloc{
    [super dealloc];
    [_requester release];
    [_downloader release];
    [_player release];
    [_dbcontroller release];
}

- (id)init{
    if (self = [super init]){
        _downloader = [[OMDownloader alloc] init];
        _dbcontroller = [[OMDBController alloc] init];
        _requester = [[OMRequester alloc] init];
    }
    return self;
}




#pragma mark - Play Actions

- (void)initializeSongs:(NSArray *)songs{
    
}

- (void)Start{
    
}

- (void)Pause{
    
}

- (void)Previous{
    
}

- (void)Next{
    
}

- (void)Seek:(double)time{
    
}

- (void)Setmode:(int)_mode{
    
}

#pragma mark - Download Actions

- (void)addSong:(OMSong *)song{
    [_downloader addSong:song];
    [_dbcontroller addDownloadSong:song];
    [_requester requestAudioUrl:song WithBlock:^(NSURL *url) {
        [_downloader startSong:song withUrl:url];
    }];
}

- (void)removeSong:(OMSong *)song{
    [_dbcontroller removeDownloadSong:song];
    [_downloader removeSong:song];
}

- (void)closeSong:(OMSong *)song{
    [_downloader stopSong:song];
}







@end
