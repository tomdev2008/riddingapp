//
//  Weather.m
//  Ridding
//
//  Created by zys on 13-2-17.
//
//

#import "Weather.h"
#import "NSString+Addition.h"
@implementation Weather

- (id)initWithJSONDic:(NSDictionary *)jsonDic {
  
  self = [super init];
  if (self) {
    _tempMaxC = [[jsonDic objectForKey:@"tempMaxC"] intValue];
    _tempMinC = [[jsonDic objectForKey:@"tempMinC"] intValue];
    NSArray *descArray=[jsonDic objectForKey:@"weatherIconUrl"];
    _weatherIconUrls=[[NSMutableArray alloc]init];
    for(NSDictionary *dic in descArray){
      [_weatherIconUrls addObject:[dic objectForKey:@"value"]];
    }
    if([_weatherIconUrls count]>0){
      _url=[_weatherIconUrls objectAtIndex:0];
    }
    _windspeedKmph = [[jsonDic objectForKey:@"windspeedKmph"] intValue];
    _winddirection = [jsonDic objectForKey:@"winddirection"];
  }
  [self urlFromUrl];
  return self;
  
}


- (NSString*)weatherDescStr{
  NSMutableString *mulStr=[[NSMutableString alloc]init];
  for(NSString *str in _weatherIconUrls){
    if([str isContainStr:@"sunny"]){
      return @"天气晴朗";
    }
    if([str isContainStr:@"cloud"]){
      return @"多云";
    }
    if([str isContainStr:@"rain"]){
      return @"下雨天";
    }
    if([str isContainStr:@"snow"]){
      return @"下雪天";
    }
    if([str isContainStr:@"thunderstorms"]){
      return @"风暴";
    }
  }
  return mulStr;
}

- (NSString*)urlFromUrl{
  NSString *url=[_url stringByReplacingOccurrencesOfString:WeatherOnlineUrl withString:imageHost];
  return url;
}

- (NSString*)subTitle{
  return [NSString stringWithFormat:@"%@ %@",[self winddirectionStr],[self windspeedKmphStr]];
}

- (NSString*) windspeedKmphStr{
  return [NSString stringWithFormat:@"%d公里/小时",_windspeedKmph];
}

- (NSString*)winddirectionStr{
  
  if([_winddirection isContainStr:@"NE"]||[_winddirection isContainStr:@"EN"]){
    return @"东北风";
  }
  if([_winddirection isContainStr:@"SE"]||[_winddirection isContainStr:@"ES"]){
    return @"东南风";
  }
  if([_winddirection isContainStr:@"WS"]||[_winddirection isContainStr:@"SW"]){
    return @"西南风";
  }
  if([_winddirection isContainStr:@"WN"]||[_winddirection isContainStr:@"NW"]){
    return @"西北风";
  }
  if([_winddirection isContainStr:@"E"]){
    return @"东风";
  }
  if([_winddirection isContainStr:@"N"]){
    return @"北风";
  }
  if([_winddirection isContainStr:@"S"]){
    return @"南风";
  }
  if([_winddirection isContainStr:@"W"]){
    return @"西风";
  }
  return nil;
}


@end
