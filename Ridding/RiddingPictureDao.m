//
//  RiddingPictureDao.m
//  Ridding
//
//  Created by zys on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RiddingPictureDao.h"
#import "RiddingPicture.h"
#define columCount 11
static RiddingPictureDao *riddingPictureDao=nil;
@implementation RiddingPictureDao
@synthesize sqlUtil=_sqlUtil;
- (id)init
{
  self = [super init];
  if (self) {
    self.sqlUtil=[SqlUtil getSinglton];
  }
  return self;
}

+ (RiddingPictureDao*)getSinglton
{
  @synchronized(self) {
    if (riddingPictureDao == nil) {
      riddingPictureDao=[[self alloc] init]; // assignment not done here
    }
  }
  return riddingPictureDao;
}


-(Boolean)addRiddingPicture:(RiddingPicture*)picture {
  [self.sqlUtil readyDatabse];
  NSMutableArray *mulArray=[[NSMutableArray alloc]init];
  [mulArray addObject:LONGLONG2NUM(picture.riddingId)];
  [mulArray addObject:DOUBLE2STR(picture.latitude)];
  [mulArray addObject:DOUBLE2STR(picture.longtitude)];
  [mulArray addObject:SAFESTR(picture.fileName)];
  [mulArray addObject:LONGLONG2NUM(picture.user.userId)];
  [mulArray addObject:SAFESTR(picture.pictureDescription)];
  [mulArray addObject:SAFESTR(picture.location)];
  [mulArray addObject:LONGLONG2STR(picture.takePicDateL)];
  [mulArray addObject:INT2STR(picture.width)];
  [mulArray addObject:INT2STR(picture.height)];
  NSString *sql =@"INSERT INTO TB_RiddingPicture (riddingid, latitude,longtitude,filename,userid,description,location,takepicdate,width,height) VALUES (?,?,?,?,?,?,?,?,?,?)";
    return [self.sqlUtil dealData:sql paramArray:mulArray];
}

-(NSArray*)getRiddingPicture:(long long)riddingId userId:(long long)userId{
  [self.sqlUtil readyDatabse];
  NSString *sql = [NSString stringWithFormat:@"select * from TB_RiddingPicture where riddingid =%lld and userid=%lld ;",riddingId,userId];
  NSMutableArray *mulArray=[self.sqlUtil selectData:sql resultColumns:columCount];
  if (!mulArray) {
    return nil;
  }
  NSMutableArray *riddingPictures=[[NSMutableArray alloc]init];
  for(NSArray *row in mulArray){
    RiddingPicture *picture=[[RiddingPicture alloc]init];
    picture.dbId=[[row objectAtIndex:0]longLongValue];
    picture.riddingId=[[row objectAtIndex:1]longLongValue];
    picture.latitude=[[row objectAtIndex:2]doubleValue];
    picture.longtitude=[[row objectAtIndex:3]doubleValue];
    picture.fileName=[row objectAtIndex:4];
    picture.user.userId=[[row objectAtIndex:5]longLongValue];
    picture.pictureDescription=[row objectAtIndex:6];
    picture.location=[row objectAtIndex:7];
    picture.takePicDateL=[[row objectAtIndex:8]longLongValue];
    picture.width=[[row objectAtIndex:9]intValue];
    picture.height=[[row objectAtIndex:10]intValue];
    [riddingPictures addObject:picture];
  }
  return [riddingPictures copy];
}

-(long long)getMaxRiddingPictureId:(long long)riddingId userId:(long long)userId{
  [self.sqlUtil readyDatabse];
  NSString *sql = [NSString stringWithFormat:@" select max(id) from TB_RiddingPicture where riddingid = %lld and userid= %lld ",riddingId,userId];
  NSMutableArray *mulArray=[self.sqlUtil selectData:sql resultColumns:1];
  if (!mulArray) {
    return -1;
  }
  for(NSArray *row in mulArray){
    return [[row objectAtIndex:0]intValue];
  }
  return -1;
}

-(BOOL)deleteRiddingPicture:(long long)riddingId userId:(long long)userId dbId:(long long)dbId{
  [self.sqlUtil readyDatabse];
  NSString *sql = [NSString stringWithFormat:@"delete from TB_RiddingPicture where riddingid = %lld and userid= %lld and id= %lld",riddingId,userId,dbId];
  return [self.sqlUtil dealData:sql paramArray:nil];
}

-(BOOL)updateRiddingPictureText:(NSString*)pictureDescription dbId:(long long)dbId{
  [self.sqlUtil readyDatabse];
  NSArray *paramArray=[[NSArray alloc]initWithObjects:SAFESTR(pictureDescription), nil];
  NSString *sql = [NSString stringWithFormat:@"update TB_RiddingPicture set description = ? where id= %lld",dbId];
  return [self.sqlUtil dealData:sql paramArray:paramArray];
}


-(int)getNextDbId:(long long)riddingId userId:(long long)userId{
  int dbId= [[RiddingPictureDao getSinglton] getMaxRiddingPictureId:riddingId userId:userId];
  return dbId+1;
}
@end
