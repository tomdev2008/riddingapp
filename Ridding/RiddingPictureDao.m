//
//  RiddingPictureDao.m
//  Ridding
//
//  Created by zys on 13-3-11.
//
//

#import "RiddingPictureDao.h"
#import "FMDatabase.h"
#import "StaticInfo.h"
@implementation RiddingPictureDao

+ (Boolean)addRiddingPicture:(RiddingPicture*)riddingPicture{
  
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  if (!db) {
    return FALSE;
  }
  [db executeUpdate:@"INSERT INTO TB_RiddingPicture (riddingid, latitude,longtitude,filename,userid,description,location,takepicdate,width,height) VALUES (?,?,?,?,?,?,?,?,?,?)", LONGLONG2NUM(riddingPicture.riddingId), DOUBLE2STR(riddingPicture.latitude), DOUBLE2STR(riddingPicture.longtitude), riddingPicture.filePath,LONGLONG2NUM([StaticInfo getSinglton].user.userId),riddingPicture.pictureDescription,riddingPicture.location,LONGLONG2NUM(riddingPicture.takePicDateL),INT2NUM(riddingPicture.width),INT2NUM(riddingPicture.height)];
  return TRUE;
}

+ (NSArray *)getRiddingPictures{
  
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM TB_RiddingPicture"]];
  
  NSMutableArray *riddingPictures = [[NSMutableArray alloc] init];
  while ([rs next]) {
    RiddingPicture *picture = [[RiddingPicture alloc] init];
    picture.dbId=[rs longLongIntForColumn:@"id"];
    picture.riddingId=[rs longLongIntForColumn:@"riddingid"];
    picture.latitude=[rs doubleForColumn:@"latitude"];
    picture.longtitude=[rs doubleForColumn:@"longtitude"];
    picture.filePath=[rs stringForColumn:@"filename"];
    picture.user.userId=[rs longLongIntForColumn:@"userid"];
    picture.pictureDescription=[rs stringForColumn:@"description"];
    picture.location=[rs stringForColumn:@"location"];
    picture.takePicDateL=[rs longLongIntForColumn:@"takepicdate"];
    picture.width=[rs intForColumn:@"width"];
    picture.height=[rs intForColumn:@"height"];
    [riddingPictures addObject:picture];
  }
  return riddingPictures;

}

+ (void)deleteRiddingPicture:(long long)dbId{
   FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  [db executeUpdate:[NSString stringWithFormat:@"delete from TB_RiddingPicture where id=%lld",dbId]];
}

+ (int)getRiddingPictureCount{
  FMDatabase *db = [StaticInfo getSinglton].sqlDB;
  FMResultSet *rs;
  @synchronized (self) {
    rs = [db executeQuery:@"select count(*) from TB_RiddingPicture "];
    while ([rs next]) {
      return [rs intForColumnIndex:0];
    }
  }
  
  return 0;
}
@end
