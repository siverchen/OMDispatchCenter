//
//  OMDownloadActions.h
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMSong.h"

typedef enum {
    OMDownloadStateAddingToQueue,
    OMDownloadStateGetingUrl,
    OMDownloadStateWritingToDB,
    OMDownloadStateDownloadingFile,
    OMDownloadStateDownloaded
}OMDownloadState;

@protocol OMDownloadActions <NSObject>

- (void)closeSong:(OMSong *)song;
- (void)addSong:(OMSong *)song;
- (void)removeSong:(OMSong *)song;

@end
