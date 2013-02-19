//
//  Weather.m
//  Ridding
//
//  Created by zys on 13-2-17.
//
//

#import "Weather.h"

@implementation Weather

- (id)initWithJSONDic:(NSDictionary *)jsonDic {
  
  self = [super init];
  if (self) {
    _tempMaxC = [[jsonDic objectForKey:@"tempMaxC"] intValue];
    _tempMinC = [[jsonDic objectForKey:@"tempMinC"] intValue];
    NSArray *descArray=[jsonDic objectForKey:@"weatherDesc"];
    _weatherDesc=[[NSMutableArray alloc]init];
    for(NSDictionary *dic in descArray){
      [_weatherDesc addObject:[dic objectForKey:@"value"]];
    }
    _windspeedKmph = [[jsonDic objectForKey:@"windspeedKmph"] intValue];
    _winddirection = [jsonDic objectForKey:@"winddirection"];
  }
  return self;
  
}


- (NSString*)weatherDescStr{
  NSMutableString *mulStr=[[NSMutableString alloc]init];
  for(NSString *str in _weatherDesc){
    [mulStr setString:str];
  }
  return mulStr;
}

- (NSString*) windspeedKmphStr{
  return [NSString stringWithFormat:@"%d公里/小时",_windspeedKmph];
}

- (NSString*)winddirectionStr{
  if([_winddirection isEqualToString:@"NE"]||[_winddirection isEqualToString:@"EN"]){
    return @"东北风";
  }
  if([_winddirection isEqualToString:@"SE"]||[_winddirection isEqualToString:@"ES"]){
    return @"东南风";
  }
  if([_winddirection isEqualToString:@"WS"]||[_winddirection isEqualToString:@"SW"]){
    return @"西南风";
  }
  if([_winddirection isEqualToString:@"WN"]||[_winddirection isEqualToString:@"NW"]){
    return @"西北风";
  }
  if([_winddirection isEqualToString:@"E"]){
    return @"东风";
  }
  if([_winddirection isEqualToString:@"N"]){
    return @"北风";
  }
  if([_winddirection isEqualToString:@"S"]){
    return @"南风";
  }
  if([_winddirection isEqualToString:@"W"]){
    return @"西风";
  }
  return nil;
}


@end
