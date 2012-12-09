//
//  Ridding.m
//  Ridding
//
//  Created by zys on 12-12-6.
//
//

#import "Ridding.h"

@implementation Ridding


- (id)initWithJSONDic:(NSDictionary *)jsonDic{
  self=[super init];
  if(self){
    self.riddingId=[[jsonDic objectForKey:@"riddingid"]longLongValue];
    self.riddingStatus=[[jsonDic objectForKey:@"riddingstatus"]intValue];
    self.userCount=[[jsonDic objectForKey:@"usercount"]intValue];
    self.riddingName=[jsonDic objectForKey:@"riddingname"];
    self.leaderUser=[[User alloc]initWithJSONDic:[jsonDic objectForKey:@"user"]];
    self.riddingType=[[jsonDic objectForKey:@"riddingtype"]intValue];
    self.createTime=[[jsonDic objectForKey:@"createtime"]longLongValue];
    self.createTimeStr=[jsonDic objectForKey:@"createtimestr"];
    self.lastUpdateTime=[[jsonDic objectForKey:@"lastupdatetime"]longLongValue];
    self.lastUpdateTimeStr=[jsonDic objectForKey:@"lastupdatetimestr"];
    if([jsonDic objectForKey:@"map"]){
       self.map=[[Map alloc]initWithJSONDic:[jsonDic objectForKey:@"map"]];
    }
    NSArray *array=[jsonDic objectForKey:@"riddingpictures"];
    if(array){
      self.riddingPictures=[[NSMutableArray alloc]init];
      
      for(NSDictionary *dic in array){
        RiddingPicture *picture=[[RiddingPicture alloc]initWithJSONDic:dic];
        [self.riddingPictures addObject:picture];
      }
    }

  }
  return self;
}

- (BOOL)isEnd{
  return self.riddingStatus == 10?FALSE:TRUE;
}

- (void)setEnd{
  self.riddingStatus=20;
}

+ (BOOL)isLeader:(int)userRole{
  if(userRole==20){
    return TRUE;
  }
  return FALSE;
}
@end
