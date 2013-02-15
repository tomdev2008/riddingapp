//
//  UserNearBy.m
//  Ridding
//
//  Created by zys on 13-2-8.
//
//

#import "UserNearBy.h"

@implementation UserNearBy


- (id)initWithJSONDic:(NSDictionary *)jsonDic {
  
  self = [super initWithJSONDic:jsonDic];
  if (self) {
    
    _distance=[[jsonDic objectForKey:@"distance"]intValue];
    _user=[[User alloc]initWithJSONDic:[jsonDic objectForKey:keyUser]];
    
  }
  return self;
  
}
@end
