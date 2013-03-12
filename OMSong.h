//
//  OMSong.h
//  OMusicHD
//
//  Created by Chen Lei on 12-11-28.
//  Copyright (c) 2012年 cmc. All rights reserved.
//

#import "OMBase.h"

@interface OMSong : OMBase


- (NSString *)songid;
- (NSString *)songname;
- (NSString *)singerid;
- (NSString *)singername;
- (NSString *)albumid;
- (NSString *)albumname;
- (NSString *)pubtime;
- (NSString *)songstyle;


- (void)setSongid:(NSString *)songid;
- (void)setSongname:(NSString *)songname;
- (void)setSingerid:(NSString *)singerid;
- (void)setSingername:(NSString *)singername;
- (void)setAlbumid:(NSString *)albumid;
- (void)setAlbumname:(NSString *)albumname;
- (void)setPubtime:(NSString *)pubtime;
- (void)setSongstyle:(NSString *)songstyle;

- (BOOL)isEqualSong:(OMSong *)song;
- (BOOL)isiPodSong;

- (NSString *)status;
- (void)setStatus:(NSString *)status;

@end
