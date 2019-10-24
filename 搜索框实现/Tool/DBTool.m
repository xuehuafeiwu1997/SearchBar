//
//  DBTool.m
//  搜索框实现
//
//  Created by 许明洋 on 2019/9/11.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "DBTool.h"
#import "FMDatabase.h"

static FMDatabase *_db;

@implementation DBTool

+ (void)initialize {
    
    //1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"search.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_search (id integer PRIMARY KEY, searchData blob NOT NULL, search_idstr varchar NOT NULL);"];
    
}

+ (id)statusesWithKey:(NSString *)key {
    
    //根据请求参数生成对应的查询SQL语句
    NSString *sql = nil;
    if (key.length > 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_search WHERE search_idstr = '%@';",key];
    } else {
        sql = @"SELECT * FROM t_search;";
    }
    
    //执行sql语句
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        NSData *statusData = [set objectForColumn:@"searchData"];
        id status = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        return status;
    }
    return @[];
}

+ (void)saveStatuses:(id)statuses key:(NSString *)key {
    [DBTool delete:key];
    NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:statuses];
    [_db executeUpdateWithFormat:@"INSERT INTO t_search(searchData,search_idstr) VALUES (%@,%@);",statusData,key];
}

+ (BOOL)delete:(NSString *)search_idstr {
    BOOL success = YES;
    NSString *newSql = [NSString stringWithFormat:@"DELETE FROM t_search WHERE search_idstr = ?"];
    BOOL isCan = [_db executeUpdate:newSql,search_idstr];
    if (!isCan) {
        success = NO;
    }
    return success;
}
@end
