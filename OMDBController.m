//
//  OMDBController.m
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import "OMDBController.h"
#import "OMDBManager.h"
#import "OMSong.h"

@interface OMDBController (){
    OMDBManager *_manager;
}

@end

@implementation OMDBController


- (id)init{
    if (self = [super init]){
        _manager = [[OMDBManager alloc] init];
    }
    return self;
}

- (BOOL)addDownloadSong:(OMSong *)song{
    return [_manager insertData:song.data toTable:@"OMDownloadSong"];
}

- (NSArray *)getDownladSongs{
    return [_manager queryFromTable:@"OMDownloadSong" Where:nil Start:@"0" limit:@"9999" Desc:NO OrderBy:nil];
}

- (BOOL)removeDownloadSong:(OMSong *)song{
    return [_manager deleteDataFromTable:@"OMDownloadSong" where:[NSString stringWithFormat:@"songid = %@", song.songid]];
}


    
@end
