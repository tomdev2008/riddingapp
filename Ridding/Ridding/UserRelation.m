//
//  UserRelation.m
//  Ridding
//
//  Created by zys on 13-1-4.
//
//

#import "UserRelation.h"

@implementation UserRelation

- (id)init {

  self = [super init];
  if (self) {
    self.user = [[User alloc] init];
    self.toUser = [[User alloc] init];
  }
  return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic {

  self = [super initWithJSONDic:jsonDic];
  if (self) {
    self.user = [[User alloc] initWithJSONDic:[jsonDic objectForKey:keyUser]];
    self.toUser = [[User alloc] initWithJSONDic:[jsonDic objectForKey:keyToUser]];
    self.createTime = [[jsonDic objectForKey:@"createtime"] longLongValue];
    self.dbId = [[jsonDic objectForKey:@"id"] longLongValue];
    self.status = [[jsonDic objectForKey:@"status"] intValue];
  }
  return self;
}
@end
