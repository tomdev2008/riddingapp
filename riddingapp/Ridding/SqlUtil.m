//
//  SqlUtil.m
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SqlUtil.h"
static SqlUtil *sqlUtil=nil;
@implementation SqlUtil
@synthesize path;
- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}
+ (SqlUtil*)getSinglton
{
    @synchronized(self) {
        if (sqlUtil == nil) {
            sqlUtil=[[self alloc] init]; // assignment not done here
        }
    }
    return sqlUtil;
}


- (void)readyDatabse {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"ridding.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    [self getPath]; //取得路径
  
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ridding.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
  if([self createRiddingLocationTable]&&[self createRiddingPictureTable]){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"true" forKey:@"updated"];
  }
  
}

#pragma mark 路径
- (void)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"ridding.sqlite"];
}
#pragma mark 查询数据库
/************
 sql：sql语句
 col：sql语句需要操作的表的所有字段数
 ***********/
- (NSMutableArray *)selectData:(NSString *)sql resultColumns:(int)col {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];//所有记录
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        int success=sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        if (success== SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableArray *row = [[NSMutableArray alloc] init];//一条记录
                for(int i=0; i<col; i++){
                    [row addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                }
                [returnArray addObject:row];
            }//end while
        }else {
            return nil;
        }//end if
        return returnArray;
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
    }//end if
    sqlite3_close(database);
    return returnArray;
}


- (int)selectCount:(NSString *)sql{
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        int success=sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        if (success== SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                return sqlite3_column_int(statement, 0);
            }//end while
        }else {
            NSLog(@"Error: failed to prepare");
        }//end if
        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }//end if
    sqlite3_close(database);
    return -1;
}
#pragma mark 增，删，改数据库
/************
 sql：sql语句
 param：sql语句中?对应的值组成的数组
 ***********/
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param {
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to prepare=%d",success);
            return NO;
        }
        //绑定参数
        NSInteger max = [param count];
        for (int i=0; i<max; i++) {
            NSString *temp = [param objectAtIndex:i];
            sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
        }
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database");
            return NO;
        }
    }
    sqlite3_close(database);
    return TRUE;
}

//建表
- (BOOL) createRiddingLocationTable{
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        char *sql = "CREATE TABLE IF NOT EXISTS riddinglocation (id INTEGER primary key,riddingid INTEGER, \
        latitude REAl,longtitide REAl,nextDistance INTEGER,weight INTEGER);";
        sqlite3_stmt *statement;
        int success1=sqlite3_prepare_v2(database, sql, -1, &statement, nil) ;
        if(success1!= SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement:create RiddingLocation table=%d",success1);
            return NO;
        }
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to dehydrate:CREATE TABLE RiddingLocation");
            return NO;
        }
        NSLog(@"Create table 'RiddingLocation' successed.");
        return YES;
    }
    return NO;
}


- (BOOL) createRiddingPictureTable{
  if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
    char *sql = "CREATE TABLE IF NOT EXISTS riddingpicture (id INTEGER primary key,riddingid INTEGER, \
    latitude REAl,longtitide REAl,filename varchar(63),userid INTEGER,text varchar(512),location varchar(127));";
    sqlite3_stmt *statement;
    int success1=sqlite3_prepare_v2(database, sql, -1, &statement, nil) ;
    if(success1!= SQLITE_OK) {
      NSLog(@"Error: failed to prepare statement:create RiddingPicture table=%d",success1);
      return NO;
    }
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE) {
      NSLog(@"Error: failed to dehydrate:CREATE TABLE RiddingPicture");
      return NO;
    }
    NSLog(@"Create table 'RiddingPicture' successed.");
    return YES;
  }
  return NO;
}


@end
