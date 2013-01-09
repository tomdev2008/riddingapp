//
//  Comment.m
//  Ridding
//
//  Created by zys on 12-12-8.
//
//

#import "Comment.h"

@implementation Comment

-(id)init{
  self=[super init];
  if(self){
    self.user=[[User alloc]init];
    self.toUser=[[User alloc]init];
  }
  return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic{
  self=[super init];
  if(self){
    self.dbId=[[jsonDic objectForKey:@"id"]longLongValue];
    self.riddingId=[[jsonDic objectForKey:@"riddingid"]longLongValue];
    self.userId=[[jsonDic objectForKey:@"userid"]longLongValue];
    self.toUserId=[[jsonDic objectForKey:@"touserid"]longLongValue];
    self.text=[jsonDic objectForKey:@"text"];
    self.usePicUrl=[jsonDic objectForKey:@"usepicurl"];
    self.commentType=[[jsonDic objectForKey:@"commenttype"]intValue];
    self.replyId=[[jsonDic objectForKey:@"replyid"]longLongValue];
    self.createTime=[[jsonDic objectForKey:@"createtime"]longLongValue];
    self.createTimeStr=[jsonDic objectForKey:@"createtimestr"];
    self.user=[[User alloc]initWithJSONDic:[jsonDic objectForKey:@"user"]];
    self.toUser=[[User alloc]initWithJSONDic:[jsonDic objectForKey:@"touser"]];
    self.beforeTime=[jsonDic objectForKey:@"beforetime"];
  }
  return self;
}
@end
