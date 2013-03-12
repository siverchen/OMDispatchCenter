//
//  OMSong.m
//  OMusicHD
//
//  Created by Chen Lei on 12-11-28.
//  Copyright (c) 2012年 cmc. All rights reserved.
//

#import "OMSong.h"

@implementation OMSong


- (id)init{
    if (self = [super init]){
        keys = [[NSArray alloc] initWithObjects:@"songid", @"songname", @"singerid", @"singername", @"albumid", @"albumname", @"pubtime", @"songstyle", @"status", nil];
    }
    return self;
}


- (NSString *)songid{
    return [data objectForKey:@"songid"];
}
- (NSString *)songname{
    return [data objectForKey:@"songname"];
}
- (NSString *)singerid{
    return [data objectForKey:@"singerid"]; 
}
- (NSString *)singername{
    return [data objectForKey:@"singername"];
}
- (NSString *)albumid{
    return [data objectForKey:@"albumid"];
}
- (NSString *)albumname{
    return [data objectForKey:@"albumname"];
}
- (NSString *)pubtime{
    return [data objectForKey:@"pubtime"];
}
- (NSString *)songstyle{
    return [data objectForKey:@"songstyle"];
}

- (NSString *)status{
    return [data objectForKey:@"status"];
}



- (void)setSongid:(NSString *)songid{
    [data setObject:songid forKey:@"songid"];
}
- (void)setSongname:(NSString *)songname{
    [data setObject:songname forKey:@"songname"];
}
- (void)setSingerid:(NSString *)singerid{
    [data setObject:singerid forKey:@"singerid"];
}
- (void)setSingername:(NSString *)singername{
    [data setObject:singername forKey:@"singername"];
}
- (void)setAlbumid:(NSString *)albumid{
    [data setObject:albumid forKey:@"albumid"];
}
- (void)setAlbumname:(NSString *)albumname{
    [data setObject:albumname forKey:@"albumname"];
}
- (void)setPubtime:(NSString *)pubtime{
    [data setObject:pubtime forKey:@"pubtime"];
}
- (void)setSongstyle:(NSString *)songstyle{
    [data setObject:songstyle forKey:@"songstyle"];
}

- (void)setStatus:(NSString *)status{
    [data setObject:status forKey:@"status"];
}

- (BOOL)isEqualSong:(OMSong *)song{
    return [[NSString stringWithFormat:@"%@", song.songid] isEqualToString:[NSString stringWithFormat:@"%@", self.songid]];
}

- (BOOL)isiPodSong{
    return [self.songid isKindOfClass:[NSNumber class]] || self.songid.length > 15;
}

@end
