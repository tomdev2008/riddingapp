//
//  Public.m
//  Ridding
//
//  Created by zys on 13-2-5.
//
//

#import "Public.h"

@implementation Public


- (id)init {
  
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (id)initWithJSONDic:(NSDictionary *)jsonDic {
  
  self = [super initWithJSONDic:jsonDic];
  if (self) {
    
    _dbId=[[jsonDic objectForKey:@"dbid"]longLongValue];
    _weight=[[jsonDic objectForKey:@"weight"]intValue];
    _riddingId=[[jsonDic objectForKey:@"riddingid"]longLongValue];
    _linkText=[jsonDic objectForKey:@"linktext"];
    _linkImageUrl=[jsonDic objectForKey:@"linkimageurl"];
    _linkUrl=[jsonDic objectForKey:@"linkurl"];
    _firstPicUrl=[jsonDic objectForKey:@"firstpicurl"];
    _adContentType=[[jsonDic objectForKey:@"adcontenttype"]intValue];

  }
  return self;
}
@end
