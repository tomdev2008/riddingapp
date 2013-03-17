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
    _ridding = [[Ridding alloc] init];
  }
  return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic {

  self = [super init];
  if (self) {
    _ridding = [[Ridding alloc] initWithJSONDic:[jsonDic objectForKey:keyRidding]];
  }
  return self;

}


@end
