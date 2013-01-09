//
//  User.m
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "QiNiuUtils.h"
@implementation User
- (id)init
{
  self = [super init];
  if (self) {
  }
  
    return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic{
  self=[super init];
  if(self){
    self.accessToken=[jsonDic objectForKey:@"accesstoken"];
    self.name=[jsonDic objectForKey:@"username"];
    self.userId=[[jsonDic objectForKey:@"userid"]longLongValue];
    self.sourceUserId=[[jsonDic objectForKey:@"sourceid"]longLongValue];
    self.totalDistance=[[jsonDic objectForKey:@"totaldistance"]intValue];
    self.sourceType=[[jsonDic objectForKey:@"sourcetype"]intValue];
    self.nowRiddingCount=[[jsonDic objectForKey:@"nowriddingcount"]intValue];
    self.bavatorUrl=[jsonDic objectForKey:@"bavatorurl"];
    self.savatorUrl=[jsonDic objectForKey:@"savatorurl"];
    self.authToken=[jsonDic objectForKey:@"authtoken"];
    self.isLeader=[[jsonDic objectForKey:@"isleader"]boolValue];
    self.userRole=[[jsonDic objectForKey:@"userrole"]intValue];
    self.status=[[jsonDic objectForKey:@"status"]intValue];
    self.timeBefore=[jsonDic objectForKey:@"timebefore"];
    self.latitude=[[jsonDic objectForKey:@"latitude"]doubleValue];
    self.longtitude=[[jsonDic objectForKey:@"longtitude"]doubleValue];
    self.backGroundUrl=[jsonDic objectForKey:@"backgroundurl"];
  }
  return self;
}


-(NSString*) getTotalDistanceToKm{
  float distance=self.totalDistance*1.0/1000;
  return [NSString stringWithFormat:@"%0.2lf km",distance];
}

@end
