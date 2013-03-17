//
//  UserPay.m
//  Ridding
//
//  Created by zys on 13-3-17.
//
//

#import "UserPay.h"

@implementation UserPay


- (id)initWithJSONDic:(NSDictionary *)jsonDic {
  
  self = [super init];
  if (self) {
    _userId = [[jsonDic objectForKey:@"userid"] longLongValue];
    _type=[[jsonDic objectForKey:@"typeid"] intValue];
    _status= [[jsonDic objectForKey:@"status"] intValue];
    _dayLong=[[jsonDic objectForKey:@"daylong"] intValue];
    _extdatelong=[[jsonDic objectForKey:@"extdatelong"] intValue];
  }
  return self;
}


@end
