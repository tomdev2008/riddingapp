//
//  RiddingMapPointDao.m
//  Ridding
//
//  Created by zys on 13-3-27.
//
//

#import "RiddingMapPointDao.h"
#import "FMDatabase.h"
#import "StaticInfo.h"
#import "RiddingMapPoint.h"
@implementation RiddingMapPointDao


+ (RiddingMapPoint*)getRiddingMapPoint:(long long)riddingId userId:(long long)userId{
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  FMResultSet *rs;
  @synchronized (self) {
    rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM TB_RiddingMapPoint where riddingid =%lld and userid = %lld;", riddingId,userId]];
    
    while ([rs next]) {
      RiddingMapPoint *riddingMapPoint = [[RiddingMapPoint alloc] init];
      riddingMapPoint.dbId = [rs longLongIntForColumn:@"id"];
      riddingMapPoint.riddingId = [rs longLongIntForColumn:@"riddingid"];
      riddingMapPoint.mappoint = [rs stringForColumn:@"mappoint"];
      riddingMapPoint.userId= [rs longLongIntForColumn:@"userid"];
      return riddingMapPoint;
    }
    return nil;
  }

}

+ (BOOL)addRiddingMapPointToDB:(NSString*)mapPoint riddingId:(long long)riddingId userId:(long long)userId{
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  if (!db) {
    return NO;
  }
  return [db executeUpdate:@"INSERT INTO TB_RiddingMapPoint (riddingid,mappoint,userid) VALUES (?,?,?)", LONGLONG2NUM(riddingId), mapPoint ,LONGLONG2NUM(userId)];
}


+ (BOOL)addOrUpdateRiddingMapPointToDB:(NSString*)mapPoint riddingId:(long long)riddingId userId:(long long)userId{
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  if (!db) {
    return NO;
  }
  RiddingMapPoint *riddingMapPoint=[RiddingMapPointDao getRiddingMapPoint:riddingId userId:userId];
  if(riddingMapPoint){
    return [db executeUpdate:[NSString stringWithFormat:@"UPDATE TB_RiddingMapPoint set mappoint='%@' where riddingid =%lld and userid=%lld",mapPoint,riddingId,userId]];
  }else{
    return [db executeUpdate:@"INSERT INTO TB_RiddingMapPoint (riddingid,mappoint,userid) VALUES (?,?,?)", LONGLONG2NUM(riddingId), mapPoint ,LONGLONG2NUM(userId)];
  }
}
@end
