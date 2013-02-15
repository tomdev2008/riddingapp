//
//  ActivityInfo.m
//  Ridding
//
//  Created by Wu Chenhao on 6/9/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

@implementation ActivityInfo

- (id)init {

  self = [super init];
  if (self) {
    self.ridding = [[Ridding alloc] init];
  }
  return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic {

  self = [super initWithJSONDic:jsonDic];
  if (self) {
    self.ridding = [[Ridding alloc] initWithJSONDic:[jsonDic objectForKey:keyRidding]];
    self.weight = [[jsonDic objectForKey:@"weight"] intValue];
    self.firstPicUrl = [jsonDic objectForKey:@"firstpicurl"];
  }
  return self;

}


@end
