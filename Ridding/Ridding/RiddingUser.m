//
//  RiddingUser.m
//  Ridding
//
//  Created by zys on 13-3-26.
//
//

#import "RiddingUser.h"

@implementation RiddingUser


- (id)initWithJSONDic:(NSDictionary *)jsonDic {
  
  self = [super init];
  if (self) {
    _user = [[User alloc]initWithJSONDic:[jsonDic objectForKey:keyUser]];
    _gpsMap=[[GpsMap alloc]initWithJSONDic:[jsonDic objectForKey:keyGpsMap]];
    _userRole=[[jsonDic objectForKey:@"userrole"]intValue];
  
  }
  return self;
}
@end
