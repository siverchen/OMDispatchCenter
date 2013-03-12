//
//  OMBase.h
//  OMusicHD
//
//  Created by Chen Lei on 12-11-28.
//  Copyright (c) 2012年 cmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMBase : NSObject {
    NSMutableDictionary *data;
    NSString *name;
    NSArray *keys;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, copy) NSMutableDictionary *data;

- (void)filled:(NSDictionary *)_data;

@end
