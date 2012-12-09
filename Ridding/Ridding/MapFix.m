//
//  MapFix.m
//  Ridding
//
//  Created by zys on 12-12-6.
//
//

#import "MapFix.h"

@implementation MapFix


- (id)initWithJSONDic:(NSDictionary *)jsonDic{
  self=[super init];
  if(self){
    self.latitude=[[jsonDic objectForKey:@"latitude"]doubleValue];
    self.longtitude=[[jsonDic objectForKey:@"longtitude"]doubleValue];
    self.realLatitude=[[jsonDic objectForKey:@"reallatitude"]doubleValue];
    self.realLongtitude=[[jsonDic objectForKey:@"reallongtitude"]doubleValue];
  }
  return self;
}
@end
