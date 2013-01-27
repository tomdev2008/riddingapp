//
//  SinaUserProfile.m
//  Ridding
//
//  Created by zys on 12-12-8.
//
//

#import "SinaUserProfile.h"

@implementation SinaUserProfile

- (id)initWithJSONDic:(NSDictionary *)jsonDic {

  self = [super init];
  if (self) {
    if ([jsonDic objectForKey:@"uid"]) {
      self.dbId = [[jsonDic objectForKey:@"uid"] longLongValue];
    } else {
      self.dbId = [[jsonDic objectForKey:@"id"] longLongValue];
    }
    if ([jsonDic objectForKey:@"nickname"]) {
      self.screen_name = [jsonDic objectForKey:@"nickname"];
    } else {
      self.screen_name = [jsonDic objectForKey:@"screen_name"];
    }

    self.name = [jsonDic objectForKey:@"name"];
    self.province = [[jsonDic objectForKey:@"province"] intValue];
    self.location = [jsonDic objectForKey:@"location"];
    self.profile_image_url = [jsonDic objectForKey:@"profile_image_url"];
    self.gender = [jsonDic objectForKey:@"gender"];
    self.avatar_large = [jsonDic objectForKey:@"avatar_large"];
    self.followers_count = [[jsonDic objectForKey:@"followers_count"] intValue];
    self.city = [[jsonDic objectForKey:@"city"] intValue];
  }
  return self;
}

@end
