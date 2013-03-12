//
//  OMDBManager.m
//  OMPlayer
//
//  Created by Chen Lei on 12-9-24.
//  Copyright (c) 2012年 chenlei. All rights reserved.
//

#import "OMDBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

const NSString * DB_NAME = @"cool";

@implementation OMDBManager



/**
 * 单例
 */
static OMDBManager *manager = nil;

+ (OMDBManager *)shareManager{
    if (manager == nil){
        manager = [[OMDBManager alloc] init];
    }
    return manager;
}

/**
 *创建数据库
 */

- (void)initTable{
    
    NSArray *createTableSqls = [NSArray arrayWithObjects:
                                @"CREATE TABLE OMSong (songid VARCHAR PRIMARY KEY  NOT NULL ,songname VARCHAR,singerid VARCHAR,singername char,albumid VARCHAR,albumname VARCHAR, pubtime VARCHAR, songstyle VARCHAR, md5 VARCHAR ,status VARCHAR)",//歌曲
                                @"CREATE TABLE OMArtist (singerid VARCHAR PRIMARY KEY  NOT NULL , singername VARCHAR, area VARCHAR, singerPhoto VARCHAR, style VARCHAR, description VARCHAR, md5 VARCHAR)", //艺人
                                @"CREATE TABLE OMAlbum (albumid VARCHAR PRIMARY KEY  NOT NULL , albumname VARCHAR, albumstyle VARCHAR, singerid VARCHAR, singername VARCHAR, corp VARCHAR, pubtime VARCHAR, description VARCHAR, md5 VARCHAR)", //专辑
                                @"CREATE TABLE OMRank (rankid VARCHAR PRIMARY KEY NOT NULL,rankname VARCHAR, description VARCHAR)", //排行榜
                                @"CREATE TABLE OMRecommend (recommendid VARCHAR  PRIMARY KEY  NOT NULL, recommendname VARCHAR, description VARCHAR)", //推荐
                                @"CREATE TABLE OMGendan (gedanid VARCHAR  PRIMARY KEY  NOT NULL,gedantype VARCHAR, gedanname VARCHAR, addtime VARCHAR, description VARCHAR)", //歌单
                                @"CREATE TABLE OMLyric (id VARCHAR  PRIMARY KEY  NOT NULL, content VARCHAR)", //歌词
                                @"CREATE TABLE OMMap (pname VARCHAR  PRIMARY KEY  NOT NULL, pvalue VARCHAR)", //歌词
                                @"CREATE TABLE OMRadio (radioid VARCHAR PRIMARY KEY  NOT NULL, radioname VARCHAR, description VARCHAR)", //电台
                                @"CREATE TABLE OMFolder (folderid VARCHAR PRIMARY KEY  NOT NULL, foldername VARCHAR, position Integer, description VARCHAR, addtime VARCHAR)", //自建列表
                                @"CREATE TABLE OMHistory (content VARCHAR PRIMARY KEY  NOT NULL, time VARCHAR)", //搜索历史
                                @"CREATE TABLE OMRankSong (rankid VARCHAR, songid VARCHAR, change VARCHAR, position VARCHAR, UNIQUE (rankid, songid))", //排行榜关系表
                                @"CREATE TABLE OMRecommendAlbum (recommendid VARCHAR, albumid VARCHAR,reason VARCHAR, position VARCHAR, UNIQUE (recommendid, albumid))", //推荐专辑关系表
                                @"CREATE TABLE OMRecommendSong (recommendid VARCHAR, songid VARCHAR,reason VARCHAR, position VARCHAR, UNIQUE (recommendid, songid))", //推荐歌曲关系表
                                @"CREATE TABLE OMRecommendArtist (recommendid VARCHAR, singerid VARCHAR,reason VARCHAR, position VARCHAR, UNIQUE (recommendid, singerid))", //推荐艺人关系表
                                @"CREATE TABLE OMRecommendGedan (recommendid VARCHAR, gedanid VARCHAR, reason VARCHAR, position VARCHAR, UNIQUE (recommendid, gedanid))", //推荐歌单关系表
                                @"CREATE TABLE OMRadioSong (radioid VARCHAR, songid VARCHAR, position VARCHAR, UNIQUE (radioid, songid))", //电台歌曲关系表
                                @"CREATE TABLE OMGedanSong (gedanid VARCHAR, songid VARCHAR, position VARCHAR, UNIQUE (gedanid, songid))", //歌单歌曲关系表
                                @"CREATE TABLE OMAlbumSong (albumid VARCHAR, songid VARCHAR, position VARCHAR, UNIQUE (albumid, songid))", //专辑歌曲关系表
                                @"CREATE TABLE OMArtistSong (singerid VARCHAR, songid VARCHAR, position VARCHAR, UNIQUE (singerid, songid))", //艺人歌曲关系表
                                @"CREATE TABLE OMFolderSong (folderid VARCHAR, songid VARCHAR, position Integer, UNIQUE (folderid, songid))", //艺人歌曲关系表
                                @"CREATE TABLE OMUserFolder (userid VARCHAR, folderid VARCHAR, UNIQUE (userid, folderid))", //用户歌单表
                                @"CREATE TABLE OMDownloadSong (songid VARCHAR PRIMARY KEY  NOT NULL)", //用户歌单表
                                nil];
    
    [db open];
	[db beginTransaction];
    
    for (NSString *sql in createTableSqls){
        if (![db executeUpdate:sql]){
//            NSLog(@"%@", sql);
            [db rollback];
            break;
        }
    }
	[db commit];
	[db close];
}

/**
 * 重写init函数
 */


- (id)init{
    if (self = [super init]){
        NSString *documentsDir = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		NSString *tmpPath =  [documentsDir stringByAppendingPathComponent:@"OMusic.sqlite"];//@"/Users/siverchen/uu.sqlite"; //
		if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
			db = [[FMDatabase alloc] initWithPath:tmpPath];
			[self initTable];
		}else {
			db = [[FMDatabase alloc] initWithPath:tmpPath];
		}
    }
    return self;
}

/**
 *创建数据表
 */

- (void)createTable:(NSString *)tablename{
    
}

/**
 *删除数据表
 */

- (void)dropTable:(NSString *)tablename{
    
    @synchronized (db){
        [db executeQuery:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tablename]];
//        NSLog(@"%@ 已经被删除了", tablename);
    }
}

/**
 *打开数据库连接
 */

- (BOOL)openDB{
    return [db open];
}

/**
 *关闭数据库连接
 */


- (BOOL)closeDB{
    return [db close];
}



/**
 *获取数据
 */


- (NSMutableArray *)queryFromTable:(NSString *)name
                             Where:(NSString *)where
                             Start:(NSString *)start
                             limit:(NSString *)limit
                              Desc:(BOOL)desc
                           OrderBy:(NSString *)orderby{
    NSMutableArray *result = [NSMutableArray array];
    @synchronized (self){
        [db open];
        NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ ", name];
        if (where){
            [sql appendFormat:@"where %@ ", where];
        }
        if (orderby){
            [sql appendFormat:@"order by %@ %@ ", orderby, desc ? @"desc" : @"asc"];
        }
        if (limit > 0){
            [sql appendFormat:@"limit %@, %@ ", start, limit];
        }
//        NSLog(@".....sql lang :%@",sql);
        FMResultSet *rs = [db executeQuery:sql];
        if (rs){
            while ([rs next]) {
                [result addObject:[rs resultDictionary]];
            }
        }
        [db close];
    }
	return result;
}

/**
 *插入数据
 */


- (BOOL)insertData:(id)data toTable:(NSString *)name{
    @synchronized (self){
        if ([data isKindOfClass:[NSDictionary class]]){
            [db open];
            
            NSMutableArray *s = [[NSMutableArray alloc] init];
            for (id value in [data allValues]){
                [s addObject:@"?"];
            }
            NSString *sql = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE into %@ (%@) values (%@)", name, [[data allKeys] componentsJoinedByString:@","], [s componentsJoinedByString:@","]];
            BOOL result = [db executeUpdate:sql withArgumentsInArray:[data allValues]];
            [db close];
            [s release];
            [sql release];
            return  result;
        }else {
            [db open];
            for (NSMutableDictionary *_data in data){
                NSMutableArray *s = [[NSMutableArray alloc] init];
                for (id value in [_data allValues]){
                    [s addObject:@"?"];
                }
                
                NSString *sql = [[NSString alloc] initWithFormat:@"INSERT OR REPLACE into %@ (%@) values (%@)", name, [[_data allKeys] componentsJoinedByString:@","], [s componentsJoinedByString:@","]];
                
                if (![db executeUpdate:sql withArgumentsInArray:[_data allValues]]){
//                    NSLog(@"%@", sql);
//                    NSLog(@"error");
                }
                [sql release];
                [s release];
            }
            [db close];
            
            return YES;
        }
        return  NO;
    }
}

/**
 *插入更新数据
 */


- (BOOL)insertupdateData:(id)data toTable:(NSString *)name{
    @synchronized (self){
        if ([data isKindOfClass:[NSDictionary class]]){
            NSArray *keys =[data allKeys];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSString *key in keys){
                [tempArray addObject:[NSString stringWithFormat:@"%@ = '%@'", key, [data objectForKey:key]]];
            }
            [db open];
            NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@ (%@) values ('%@') ON DUPLICATE KEY UPDATE %@", name, [[data allKeys] componentsJoinedByString:@","], [[data allValues] componentsJoinedByString:@"','"], [tempArray componentsJoinedByString:@","]];
            BOOL result = [db executeUpdate:sql];
            [db close];
            [sql release];
            return  result;
        }else {
            [db open];
            [db beginTransaction];
            for (NSMutableDictionary *_data in data){
                NSString *sql = [[NSString alloc] initWithFormat:@"insert into %@ (%@) values ('%@')", name, [[_data allKeys] componentsJoinedByString:@","], [[_data allValues] componentsJoinedByString:@"','"]];
                if (![db executeUpdate:sql]){
                    [db rollback];
                }
                [sql release];
            }
            BOOL result = [db commit];
            [db close];
            return result;
        }
        return  NO;
    }
}

/**
 *更新数据
 */


- (BOOL)updateData:(id)data toTable:(NSString *)name where:(NSString *)where{
    @synchronized (self){
        [db open];
        NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"update  %@ set ", name];
        NSArray *keys =[data allKeys];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSString *key in keys){
            [tempArray addObject:[NSString stringWithFormat:@"%@ = (?)", key]];//[data objectForKey:key]
        }
        [sql appendString:[tempArray componentsJoinedByString:@","]];
        if (where){
            [sql appendFormat:@" where %@", where];
        }
        if (![db executeUpdate:sql withArgumentsInArray:[data allValues]]){
            [db rollback];
        }
        [sql release];
        BOOL result = [db commit];
        //BOOL result = [database executeUpdate:sql];
        [db close];
        return  result;
    }
}

/**
 *删除数据
 */

- (BOOL)deleteDataFromTable:(NSString *)name where:(NSString *)where{
	@synchronized (self){
        [db open];
        NSMutableString *sql = [[NSMutableString alloc] initWithFormat:@"delete from %@", name];
        if (where){
            [sql appendFormat:@" where %@", where];
        }
        BOOL result = [db executeUpdate:sql];
        [db close];
        [sql release];
        
        return  result;
    }
}

/**
 *直接执行sql语句
 */
- (BOOL)executeSql:(NSString *)sql{
	@synchronized (self){
        [db open];
        BOOL result = [db executeUpdate:sql];
        [db close];
        return  result;
    }
}
/**
 *直接执行查询
 */

- (NSArray *)executeSelectSql:(NSString *)sql{
    NSMutableArray *result = [NSMutableArray array];
    @synchronized (self){
        [db open];
        FMResultSet *rs = [db executeQuery:sql];
        if (rs){
            while ([rs next]) {
                [result addObject:[rs resultDictionary]];
            }
        }
        [db close];
    }
    return result;
}


@end
