//
//  Map.m
//  Ridding
//
//  Created by zys on 12-12-6.
//
//

@implementation Map


- (id)initWithJSONDic:(NSDictionary *)jsonDic {

  self = [super init];
  if (self) {
    
    self.mapId = [[jsonDic objectForKey:@"mapid"] longLongValue];
    self.mapUrl = [jsonDic objectForKey:@"mapurl"];
    self.mapTaps = [jsonDic objectForKey:@"maptaps"];
    self.createTimeStr = [jsonDic objectForKey:@"createtimestr"];
    self.objectId = [[jsonDic objectForKey:@"objectid"] longLongValue];
    self.objectType = [[jsonDic objectForKey:@"objecttype"] intValue];
    self.status = [[jsonDic objectForKey:@"status"] intValue];
    self.mapPoint = [jsonDic objectForKey:@"mappoint"];
    self.distance = [[jsonDic objectForKey:@"distance"] intValue];
    self.beginLocation = [jsonDic objectForKey:@"beginlocation"];
    self.endLocation = [jsonDic objectForKey:@"endlocation"];
    self.midLocation = [jsonDic objectForKey:@"midlocation"];
    self.cityId = [[jsonDic objectForKey:@"cityid"] longLongValue];
    self.cityName = [jsonDic objectForKey:@"cityname"];
    self.avatorPicUrl = [jsonDic objectForKey:@"avatorpicurl"];
  }
  return self;
}

- (NSString *)totalDistanceToKm {
  float distance = self.distance * 1.0 / 1000;
  return [NSString stringWithFormat:@"%0.2lf KM", distance];
}


@end
