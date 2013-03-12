//
//  OMDBController.h
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OMSong;

@interface OMDBController : NSObject

- (BOOL)addDownloadSong:(OMSong *)song;
- (NSArray *)getDownladSongs;
- (BOOL)removeDownloadSong:(OMSong *)song;

@end
