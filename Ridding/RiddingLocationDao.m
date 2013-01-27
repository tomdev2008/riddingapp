//
//  RiddingLocationDao.m
//  Ridding
//
//  Created by zys on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RiddingLocationDao.h"
#import "FMDatabase.h"
#import "StaticInfo.h"
@implementation RiddingLocationDao

//   char *sql = "CREATE TABLE IF NOT EXISTS riddinglocation (id INTEGER primary key,riddingid INTEGER, \
latitude text,longtitide text,nextDistance INTEGER,weight INTEGER);";

+(Boolean)addRiddingLocation:(long long)riddingId locations:(NSArray*)locations{
  FMDatabase *db=[StaticInfo getSinglton].sqlDB;
  if(!db){
    return FALSE;
  }
  for(RiddingLocation *location in locations){
    @synchronized(self){
      [db executeUpdate:@"INSERT INTO TB_RiddingLocation (riddingid, latitude,longtitude,weight) VALUES (?,?,?,?)",LONGLONG2NUM(riddingId),DOUBLE2STR(location.latitude),DOUBLE2STR(location.longtitude),INT2STR(location.weight)];
    }
  }
  return TRUE;
}


+(NSArray*)getRiddingLocations:(long long)riddingId beginWeight:(int)beginWeight{
  FMDatabase *db=[StaticInfo getSinglton].sqlDB;
  FMResultSet *rs;
  @synchronized(self){
    rs=[db executeQuery:[NSString stringWithFormat:@"SELECT * FROM TB_RiddingLocation where riddingid =%lld and weight>=%d ;",riddingId,beginWeight]];
  }
  NSMutableArray *riddingLocations=[[NSMutableArray alloc]init];
  while ([rs next]){
    RiddingLocation *location=[[RiddingLocation alloc]init];
    location.dbId=[rs longLongIntForColumn:@"id"];
    location.riddingId=[rs longLongIntForColumn:@"riddingid"];
    location.latitude=[rs doubleForColumn:@"latitude"];
    location.longtitude=[rs doubleForColumn:@"longtitude"];
    location.weight=[rs intForColumn:@"weight"];
    [riddingLocations addObject:location];
  }
  return riddingLocations;

}

+(int)getRiddingLocationCount:(long long)riddingId{
  FMDatabase *db=[StaticInfo getSinglton].sqlDB;
  FMResultSet *rs;
  @synchronized(self){
    rs=[db executeQuery:@"select count(*) from TB_RiddingLocation where riddingid = %lld;",riddingId];
  }
  while ([rs next]){
    return [rs intForColumnIndex:0];
  }
  return 0;
}

//插入骑行的经纬度等信息到数据库
+(void)setRiddingLocationToDB:(NSArray*)routes riddingId:(long long)riddingId{
  NSMutableArray *locations=[[NSMutableArray alloc]init];
  int index=0;
  for(CLLocation *location in routes){
    RiddingLocation *riddingLocation=[[RiddingLocation alloc]init];
    riddingLocation.latitude=location.coordinate.latitude;
    riddingLocation.longtitude=location.coordinate.longitude;
    riddingLocation.riddingId=riddingId;
    riddingLocation.weight=index++;
    [locations addObject:riddingLocation];
  }
  int count= [self getRiddingLocationCount:riddingId];
  if(count>0){
      [self addRiddingLocation:riddingId locations:locations];
  }

}

@end
