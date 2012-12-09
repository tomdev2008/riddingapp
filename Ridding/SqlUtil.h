//
//  SqlUtil.h
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>
@interface SqlUtil : NSObject {
    sqlite3 *database;
    NSString *path;
}

@property(nonatomic, retain) NSString *path;

+ (SqlUtil*)getSinglton;
- (void)readyDatabse;
- (void)getPath;
- (NSMutableArray *)selectData:(NSString *)sql resultColumns:(int)col;
- (int)selectCount:(NSString *)sql;
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param;

@end
