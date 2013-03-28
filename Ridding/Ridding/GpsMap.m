//
//  GpsMap.m
//  Ridding
//
//  Created by zys on 13-3-26.
//
//

#import "GpsMap.h"

@implementation GpsMap


- (id)initWithJSONDic:(NSDictionary *)jsonDic {
  
  self = [super init];
  if (self) {
    _mappoint=[jsonDic objectForKey:@"mappoint"];
  }
  return self;
}
@end
