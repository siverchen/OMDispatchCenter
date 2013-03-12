//
//  OMDBManager.h
//  OMPlayer
//
//  Created by Chen Lei on 12-9-24.
//  Copyright (c) 2012年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>




@class FMDatabase;

/**
 * 默认的数据库名称
 */
const NSString * DB_NAME;

@interface OMDBManager : NSObject {
    
    NSString    *TAG;
	/**
	 * 数据库版本号
	 */
	int		DB_VERSION;
    /**
     * 引用数据库底层FMDB
     */
    FMDatabase *db;
    
    
    
}

@property (nonatomic, strong) NSDictionary *grouptoTable;
@property (nonatomic, strong) NSDictionary *infotoTable;

+ (OMDBManager *)shareManager;

- (void)createTable:(NSString *)tablename;

- (void)dropTable:(NSString *)tablename;

- (BOOL)openDB;

- (BOOL)closeDB;

- (BOOL)insertData:(id)data toTable:(NSString *)name;

- (BOOL)insertupdateData:(id)data toTable:(NSString *)name;

- (BOOL)updateData:(id)data toTable:(NSString *)name where:(NSString *)where;

- (BOOL)deleteDataFromTable:(NSString *)name where:(NSString *)where;

- (NSMutableArray *)queryFromTable:(NSString *)name
                             Where:(NSString *)where
                             Start:(NSString *)start
                             limit:(NSString *)limit
                              Desc:(BOOL)desc
                           OrderBy:(NSString *)orderby;

- (BOOL)executeSql:(NSString *)sql;
- (NSArray *)executeSelectSql:(NSString *)sql;



@end
