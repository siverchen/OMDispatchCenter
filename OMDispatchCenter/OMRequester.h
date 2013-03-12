//
//  OMRequester.h
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^FinishedGetUrl)(NSURL *url);

@class OMSong;

@interface OMRequester : NSObject

- (void)requestAudioUrl:(OMSong *)song WithBlock:(FinishedGetUrl)block;


@end
