//
//  RiddingPicture.m
//  Ridding
//
//  Created by zys on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RiddingPicture.h"

@implementation RiddingPicture

-(id)init{
  self=[super init];
  if(self){
    self.user=[[User alloc]init];
  }
  return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic{
  self=[super init];
  if(self){
    self.latitude=[[jsonDic objectForKey:@"latitude"]doubleValue];
    self.longtitude=[[jsonDic objectForKey:@"longtitude"]doubleValue];
    self.riddingId=[[jsonDic objectForKey:@"riddingid"]longLongValue];
    self.dbId=[[jsonDic objectForKey:@"dbid"]longLongValue];
    self.photoUrl=[jsonDic objectForKey:@"photourl"];
    self.height=[[jsonDic objectForKey:@"height"]intValue];
    self.width=[[jsonDic objectForKey:@"width"]intValue];
    self.takePicDateL=[[jsonDic objectForKey:@"takepicdatel"]longLongValue];
    self.takePicDateStr=[jsonDic objectForKey:@"takepicdatestr"];
    self.pictureDescription=[jsonDic objectForKey:@"description"];
    self.location=[jsonDic objectForKey:@"location"];
    self.user=[[User alloc]initWithJSONDic:[jsonDic objectForKey:@"user"]];
    self.createTime=[[jsonDic objectForKey:@"createtime"]longLongValue];
  }
  return self;
}

@end
