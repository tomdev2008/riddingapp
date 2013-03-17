//
//  User.m
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import "NSString+Addition.h"
@implementation User
- (id)init {

  self = [super init];
  if (self) {
  }

  return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic {

  self = [super init];
  if (self) {
    _accessToken = [jsonDic objectForKey:@"accesstoken"];
    _name = [jsonDic objectForKey:@"username"];
    _userId = [[jsonDic objectForKey:@"userid"] longLongValue];
    _sourceUserId = [[jsonDic objectForKey:@"sourceid"] longLongValue];
    _totalDistance = [[jsonDic objectForKey:@"totaldistance"] intValue];
    _sourceType = [[jsonDic objectForKey:@"sourcetype"] intValue];
    _nowRiddingCount = [[jsonDic objectForKey:@"riddingcount"] intValue];
    _bavatorUrl = [jsonDic objectForKey:@"bavatorurl"];
    _savatorUrl = [jsonDic objectForKey:@"savatorurl"];
    _authToken = [jsonDic objectForKey:@"authtoken"];
    _isLeader = [[jsonDic objectForKey:@"isleader"] boolValue];
    _userRole = [[jsonDic objectForKey:@"userrole"] intValue];
    _status = [[jsonDic objectForKey:@"status"] intValue];
    _timeBefore = [jsonDic objectForKey:@"timebefore"];
    _latitude = [[jsonDic objectForKey:@"latitude"] doubleValue];
    _longtitude = [[jsonDic objectForKey:@"longtitude"] doubleValue];
    _backGroundUrl = [jsonDic objectForKey:@"backgroundurl"];
    _graySAvatorUrl = [jsonDic objectForKey:@"graysavatorurl"];
    _taobaoCode= [jsonDic objectForKey:@"taobaocode"];
    if(![self.graySAvatorUrl pd_isNotEmptyString]){
      self.graySAvatorUrl=self.savatorUrl;
    }
  }
  return self;
}


- (NSString *)getTotalDistanceToKm {

  float distance = _totalDistance * 1.0 / 1000;
  return [NSString stringWithFormat:@"%0.2lf km", distance];
}

@end
