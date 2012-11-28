//
//  RiddingPictureDao.m
//  Ridding
//
//  Created by zys on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RiddingPictureDao.h"
#import "RiddingPicture.h"
#define columCount 6
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
    NSArray *paramarray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",picture.riddingId],[NSString stringWithFormat:@"%lf",picture.latitude],[NSString stringWithFormat:@"%lf",picture.longtitude],[NSString stringWithFormat:@"%@",picture.fileName],[NSString stringWithFormat:@"%@",picture.userId],picture.text, picture.location,nil];
    NSString *sql =@"INSERT INTO riddingpicture (riddingid, latitude,longtitide,filename,userid,text,location) VALUES (?,?,?,?,?,?,?)";
    return [self.sqlUtil dealData:sql paramArray:paramarray];
}

-(NSArray*)getRiddingPicture:riddingId userId:(NSString*)userId{
  [self.sqlUtil readyDatabse];
  NSString *sql = [NSString stringWithFormat:@" select * from riddingpicture where riddingid =%@ and userid=%@ ;",riddingId,userId];
  NSMutableArray *mulArray=[self.sqlUtil selectData:sql resultColumns:columCount];
  if (!mulArray) {
    return nil;
  }
  NSMutableArray *riddingPictures=[[NSMutableArray alloc]init];
  for(NSArray *row in mulArray){
    RiddingPicture *picture=[[RiddingPicture alloc]init];
    picture.dbId=[row objectAtIndex:0];
    picture.riddingId=[row objectAtIndex:1];
    picture.latitude=[[row objectAtIndex:2]doubleValue];
    picture.longtitude=[[row objectAtIndex:3]doubleValue];
    picture.fileName=[row objectAtIndex:4];
    picture.userId=[row objectAtIndex:5];
    if([row count]==7){
      picture.text=[row objectAtIndex:6];
    }else{
      picture.text=@"描述";
    }
    [riddingPictures addObject:picture];
  }
  return [riddingPictures copy];
}

-(int)getMaxRiddingPictureId:riddingId userId:(NSString*)userId{
  [self.sqlUtil readyDatabse];
  NSString *sql = [NSString stringWithFormat:@" select max(id) from riddingpicture where riddingid = %@ and userid= %@ ",riddingId,userId];
  NSMutableArray *mulArray=[self.sqlUtil selectData:sql resultColumns:1];
  if (!mulArray) {
    return -1;
  }
  for(NSArray *row in mulArray){
    return [[row objectAtIndex:0]intValue];
  }
  return -1;
}

-(BOOL)deleteRiddingPicture:riddingId userId:(NSString*)userId dbId:(NSString*)dbId{
  [self.sqlUtil readyDatabse];
  NSString *sql = [NSString stringWithFormat:@"delete from riddingpicture where riddingid = %@ and userid= %@ and id= %@",riddingId,userId,dbId];
  return [self.sqlUtil dealData:sql paramArray:nil];
}

-(BOOL)updateRiddingPictureText:(NSString*)text dbId:(NSString*)dbId location:(NSString*)location{
  [self.sqlUtil readyDatabse];
  NSString *sql = [NSString stringWithFormat:@"update riddingpicture set text = '%@' and location= '%@' where id= %@",text,location,dbId];
  return [self.sqlUtil dealData:sql paramArray:nil];
}


-(int)getNextDbId:(NSString*)riddingId userId:(NSString*)userId{
  int dbId= [[RiddingPictureDao getSinglton] getMaxRiddingPictureId:riddingId userId:userId];
  return dbId+1;
}
@end
