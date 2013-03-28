//
//  GpsDao.m
//  Ridding
//
//  Created by zys on 13-3-12.
//
//

#import "GpsDao.h"

@implementation GpsDao

+ (Boolean)addGps:(Gps*)gps{
  
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  if (!db) {
    return FALSE;
  }
  [db executeUpdate:@"INSERT INTO TB_Gps1 (latitude,longtitude,riddingId,userId,fixedLatitude,fixedLongtitude,altitude,speed) VALUES (?,?,?,?,?,?,?,?)", DOUBLE2NUM(gps.latitude),DOUBLE2NUM(gps.longtitude),LONGLONG2NUM(gps.riddingId),LONGLONG2NUM(gps.userId),DOUBLE2NUM(gps.fixedLatitude),DOUBLE2NUM(gps.fixedLongtitude),DOUBLE2NUM(gps.altitude),DOUBLE2NUM(gps.speed)];
  return TRUE;
}

+ (NSArray *)getGpss:(long long)riddingId userId:(long long)userId{
  
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM TB_Gps1 where riddingId = %lld and userId = %lld",riddingId,userId]];
  
  NSMutableArray *gpss = [[NSMutableArray alloc] init];
  while ([rs next]) {
    Gps *gps = [[Gps alloc] init];
    gps.dbId=[rs longLongIntForColumn:@"id"];
    gps.longtitude=[rs doubleForColumn:@"longtitude"];
    gps.latitude=[rs doubleForColumn:@"latitude"];
    gps.riddingId=[rs doubleForColumn:@"riddingId"];
    gps.userId=[rs doubleForColumn:@"userId"];
    gps.fixedLatitude=[rs doubleForColumn:@"fixedLatitude"];
    gps.fixedLongtitude=[rs doubleForColumn:@"fixedLongtitude"];
    gps.altitude=[rs doubleForColumn:@"altitude"];
    gps.speed=[rs doubleForColumn:@"speed"];
    
    [gpss addObject:gps];
  }
  return gpss;
  
}


+ (Boolean)updateReal:(Gps*)gps{
  
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  if (!db) {
    return FALSE;
  }
  if([db executeUpdate:[NSString stringWithFormat:@"update TB_Gps1 set fixedLatitude = %f, fixedLongtitude = %f where id = %lld", gps.fixedLatitude,gps.fixedLongtitude,gps.dbId]]){
    return TRUE;
  }
  return TRUE;
}
@end
