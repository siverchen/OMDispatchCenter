//
//  OMBase.m
//  OMusicHD
//
//  Created by Chen Lei on 12-11-28.
//  Copyright (c) 2012年 cmc. All rights reserved.
//

#import "OMBase.h"

@implementation OMBase

@synthesize data, name;

- (void)dealloc{
    if (keys){
        [keys release];
    }
    [data release];
    [super dealloc];
}

- (id)init{
    if (self = [super init]){
        data = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)filled:(NSDictionary *)_data{
    for (NSString *key in keys){
        [data setObject:[_data objectForKey:key] forKey:key];
    }
}

@end
