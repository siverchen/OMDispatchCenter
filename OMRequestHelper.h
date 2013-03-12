//
//  OMRequestHelper.h
//  OMusic
//
//  Created by siver on 12-12-13.
//  Copyright (c) 2012年 OceanMusic. All rights reserved.
//

#import <Foundation/Foundation.h>


#define INFOMAPDIR      [NSTemporaryDirectory() stringByAppendingFormat:@"infomap.plist"]

typedef enum {
    ImageRequestType_Square_Album_80 = 0,
    ImageRequestType_Square_Album_150,
    ImageRequestType_Square_Album_170,
    ImageRequestType_Square_Album_300,
    ImageRequestType_Square_Album_420,
    ImageRequestType_Circle_Album_170,
    ImageRequestType_Circle_Album_420,
    ImageRequestType_Square_Artist_80,
    ImageRequestType_Square_Artist_170,
    ImageRequestType_Square_Artist_185,
    ImageRequestType_Square_Artist_200150,
    ImageRequestType_Circle_Artist_170,
    ImageRequestType_Circle_Artist_420,
    ImageRequestType_Square_Songlist_150,
    ImageRequestType_Square_Songlist_420,
    ImageRequestType_Square_Radio_124114
}ImageRequestType;


@interface OMRequestHelper : NSObject {
    NSDictionary *inforequests;
    NSDictionary *listrequests;
    NSArray *imagerequests;
    NSDictionary *vcrequests;
    NSArray *infomap;
    
}

+ (OMRequestHelper *)shareHelper;
- (NSString *)getValueForKey:(NSString *)key;
- (NSURL *)generateUrl:(NSString *)vcname number:(int)number sid:(NSString *)sid start:(int)start length:(int)length;
- (NSURL *)generateImageUrl:(ImageRequestType)type Sid:(NSString *)sid;



@end
