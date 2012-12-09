//
//  User.m
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
- (id)init
{
  self = [super init];
  if (self) {
  }
  
    return self;
}


- (id)initWithJSONDic:(NSDictionary *)jsonDic{
  self=[super init];
  if(self){
    self.accessToken=[jsonDic objectForKey:@"accesstoken"];
    self.name=[jsonDic objectForKey:@"username"];
    self.userId=[[jsonDic objectForKey:@"userid"]longLongValue];
    self.sourceUserId=[[jsonDic objectForKey:@"sourceid"]longLongValue];
    self.totalDistance=[[jsonDic objectForKey:@"totaldistance"]intValue];
    self.sourceType=[[jsonDic objectForKey:@"sourcetype"]intValue];
    self.nowRiddingCount=[[jsonDic objectForKey:@"nowriddingcount"]intValue];
    self.bavatorUrl=[jsonDic objectForKey:@"bavatorurl"];
    self.savatorUrl=[jsonDic objectForKey:@"savatorurl"];
    self.authToken=[jsonDic objectForKey:@"authtoken"];
    self.isLeader=[[jsonDic objectForKey:@"isleader"]boolValue];
    self.userRole=[[jsonDic objectForKey:@"userrole"]intValue];
    self.status=[[jsonDic objectForKey:@"status"]intValue];
    self.timeBefore=[jsonDic objectForKey:@"timebefore"];
    self.latitude=[[jsonDic objectForKey:@"latitude"]doubleValue];
    self.longtitude=[[jsonDic objectForKey:@"longtitude"]doubleValue];
  }
  return self;
}

-(UIImage*)getSavator{
    if(self.savatorUrl!=nil){
         NSURL *url = [NSURL URLWithString:self.savatorUrl];
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    return [UIImage imageNamed:@"duser.png"];
}

-(UIImage*)getBavator{
    
    
    if(self.bavatorUrl!=nil){
        NSURL *url = [NSURL URLWithString:self.bavatorUrl];
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    return [UIImage imageNamed:@"duser.png"];
}

-(UIImage*) getSSavator {
    CGSize size = CGSizeMake(32, 32);
    if(self.savatorUrl!=nil){
        NSURL *url = [NSURL URLWithString:self.savatorUrl];
        return [self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]] scaleToSize:size] ;
    }
    return [self OriginImage:[UIImage imageNamed:@"duser.png"] scaleToSize:size];
}

-(UIImage*)  OriginImage:(UIImage *)image   scaleToSize:(CGSize)size    
{    
    // 创建一个bitmap的context    
    // 并把它设置成为当前正在使用的context    
    UIGraphicsBeginImageContext(size);    
    
    // 绘制改变大小的图片    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];    
    
    // 从当前context中创建一个改变大小后的图片    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();    
    
    // 使当前的context出堆栈    
    UIGraphicsEndImageContext();    
    
    // 返回新的改变大小后的图片    
    return scaledImage;    
}

-(NSString*) getTotalDistanceToKm{
  float distance=self.totalDistance*1.0/1000;
  return [NSString stringWithFormat:@"%0.2lf km",distance];
}

@end
