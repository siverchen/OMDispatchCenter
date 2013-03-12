//
//  OMPlayActions.h
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol OMPlayActions <NSObject>

//歌曲播放行为操作
- (void)initializeSongs:(NSArray *)songs;

- (void)Start;
- (void)Pause;
- (void)Seek:(double)time;
- (void)Next;
- (void)Previous;
- (void)Setmode:(int)_mode;

@end
