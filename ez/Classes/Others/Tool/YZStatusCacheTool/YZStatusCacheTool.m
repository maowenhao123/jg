//
//  YZStatusCacheTool.m
//  ez
//
//  Created by apple on 14-9-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZStatusCacheTool.h"
#import "FMDB.h"

@implementation YZStatusCacheTool

static FMDatabaseQueue *_queue;//全局变量

+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_status (id integer primary key autoincrement,status blob);"];//选号表
        
         [db executeUpdate:@"create table if not exists t_userStatus (id integer primary key autoincrement,status blob);"];//用户信息表
        
        [db executeUpdate:@"create table if not exists t_accountStatus (id integer primary key autoincrement, account varchar unique);"];//历史用户表
    }];
    
}
+ (void)saveAccount:(NSString *)account
{
    [_queue inDatabase:^(FMDatabase *db) {
        
        // 2.存储数据
        [db executeUpdate:@"insert into t_accountStatus (account) values(?)", account];
    }];
}

+ (void)saveStatus:(YZBetStatus *)status
{
    [_queue inDatabase:^(FMDatabase *db) {
        
        // 1.获得需要存储的数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:status];
        
        // 2.存储数据
        [db executeUpdate:@"insert into t_status (status) values(?)", data];
    }];
    YZLog(@"saveStatus，currentThread = %@",[NSThread currentThread]);
}

+ (void)saveUserStatusWith:(id)object
{
    [_queue inDatabase:^(FMDatabase *db) {
        
        // 1.获得需要存储的数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        
        // 2.存储数据
        [db executeUpdate:@"insert into t_userStatus (status) values(?)", data];
    }];
    YZLog(@"saveUserStatusWith，currentThread = %@",[NSThread currentThread]);
}
+ (NSArray *)getStatues//必须在主线程操作
{
    
    // 1.定义数组
    __block NSMutableArray *statusArray = nil;

        // 2.使用数据库
        [_queue inDatabase:^(FMDatabase *db) {
            // 创建数组
            statusArray = [NSMutableArray array];
            
            FMResultSet *rs = nil;
            rs = [db executeQuery:@"select * from t_status;"];
            while (rs.next) {
                NSData *data = [rs dataForColumn:@"status"];
                YZBetStatus *status = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [statusArray insertObject:status atIndex:0];
            }
        }];
    
    // 3.返回数据
    return statusArray;
}
+ (NSArray *)getUserStatues//必须在主线程操作
{
    
    // 1.定义数组
    __block NSMutableArray *userStatusArray = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        userStatusArray = [NSMutableArray array];
        
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_userStatus;"];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"status"];
            NSArray *userStatus = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [userStatusArray insertObject:userStatus atIndex:0];
        }
    }];
    
    // 3.返回数据
    return userStatusArray;
}
+ (void)deleteAllStatus
{
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {

        [db executeUpdate:@"delete from t_status;"];
    }];
}

+ (void)deleteStatusWithTag:(int)tag
{
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_status ORDER BY id desc;"];
        YZLog(@"rs = %@",[rs columnNameToIndexMap]);
        int number = 0;
        NSMutableArray *tempArr = [NSMutableArray array];
         while(rs.next) {
            number = [rs intForColumn:@"id"];
            [tempArr addObject:@(number)];
         }
        
        [db executeUpdate:@"delete from t_status where id = ?;",tempArr[tag]];
    }];
}
+ (void)deleteUserStatus//删除用户数据
{
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"delete from t_userStatus;"];
    }];
}
@end
