//
//  ActivityInfo.m
//  Ridding
//
//  Created by Wu Chenhao on 6/9/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import "ActivityInfo.h"
#import "NSString+TomAddition.h"
@implementation ActivityInfo

-(id)init{
  self=[super init];
  if(self){
    self.ridding=[[Ridding alloc]init];
  }
  return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic{
  self=[super init];
  if(self){
    self.ridding=[[Ridding alloc]initWithJSONDic:[jsonDic objectForKey:@"ridding"]];
    self.weight=[[jsonDic objectForKey:@"weight"]intValue];
    self.firstPicUrl=[jsonDic objectForKey:@"firstpicurl"];
  }
  return self;

}






@end
