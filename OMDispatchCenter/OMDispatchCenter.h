//
//  OMDispatchCenter.h
//  OMDispatchCenter
//
//  Created by Chen Lei on 13-3-12.
//  Copyright (c) 2013年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMPlayActions.h"
#import "OMDownloadActions.h"

@class OMDownloader;
@class OMPlayer;
@class OMRequester;
@class OMDBController;

@interface OMDispatchCenter : NSObject <OMPlayActions, OMDownloadActions>

@property (nonatomic, retain) OMDownloader *downloader;
@property (nonatomic, retain) OMPlayer *player;
@property (nonatomic, retain) OMRequester *requester;
@property (nonatomic, retain) OMDBController *dbcontroller;


@end
