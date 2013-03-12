//
//  NSString+More.m
//  OMPlayer
//
//  Created by Chen Lei on 12-10-18.
//  Copyright (c) 2012年 chenlei. All rights reserved.
//

#import "NSString+More.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (More)

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};



- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (void)ParseLyric:(NSMutableArray **)lyricObject andOutputLyricStamp:(NSMutableArray **)stamp{
    *lyricObject = [NSMutableArray array];
    *stamp = [NSMutableArray array];
    NSArray *lrcsArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
    
    NSError *error = nil;
    
    
    NSMutableArray *obj = [NSMutableArray array];
    
    NSMutableArray *stp = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\d+:\\d+(\\.\\d+)?\\]" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    
    for (NSString *lrcstr in lrcsArray){
        
        NSArray *matches = [regex matchesInString:lrcstr
                                          options:NSMatchingWithoutAnchoringBounds
                                            range:NSMakeRange(0, [lrcstr length])];
        
        int textstart = [[matches lastObject] range].location + [[matches lastObject] range].length;
        
        for (NSTextCheckingResult *match in matches) {
            NSString *time = [lrcstr substringWithRange:NSMakeRange(match.range.location + 1, match.range.length - 2)];
            
            NSArray *tarr = [time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":."]];
            int fulltime = 0;
            if ([tarr count] == 2){
                fulltime = ([[tarr objectAtIndex:0] intValue] * 60 + [[tarr objectAtIndex:1] intValue]) * 100;
            }else if ([tarr count] == 3){
                fulltime = ([[tarr objectAtIndex:0] intValue] * 60 + [[tarr objectAtIndex:1] intValue]) * 100 + [[tarr objectAtIndex:2] intValue];
            }
            [stp addObject:[NSString stringWithFormat:@"%d", fulltime]];
            [obj addObject:[lrcstr substringFromIndex:textstart]];
        }
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:(NSArray *)obj forKeys:(NSArray *)stp];
    
    //NSLog(@"%@", dict);
    stp = (NSMutableArray *)[stp sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int v1 = [obj1 intValue];
        int v2 = [obj2 intValue];
        if (v1 < v2)
            return NSOrderedAscending;
        else if (v1 > v2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    } ];
    for (id val in stp){
        [*lyricObject addObject:[dict objectForKey:val]];
        [*stamp addObject:val];
    }
    if (![*lyricObject count]){
        *lyricObject = (NSMutableArray *)[self componentsSeparatedByString:@"\r\n"];
    }
}

+ (NSString *) base64StringFromString:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    int length = [string length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", _base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}


+ (NSString *)sha1:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];
    
    return s;
}


- (NSString *)verifyUsername{
    NSError *error;
    __block NSString *result = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\S]+@[\\S]+$" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    [regex enumerateMatchesInString:self options:0 range:NSMakeRange(0, [self length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        result = [self substringWithRange:[match rangeAtIndex:0]];
    }];
    if (result){
        return nil;
    }else{
        return @"请输入合法邮箱";
    }
}
- (NSString *)verifyPassword{
    NSError *error;
    __block NSString *result = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\S]{6,16}$" options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    [regex enumerateMatchesInString:self options:0 range:NSMakeRange(0, [self length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        result = [self substringWithRange:[match rangeAtIndex:0]];
    }];
    if (result){
        return nil;
    }else{
        return @"密码为6-16个字符(数字、字母或特殊字符,不包含空格)";
    }
}


@end
