//
//  User.m
//  Ridding
//
//  Created by zys on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize avator;
@synthesize accessToken;
@synthesize statusTitle;
@synthesize annotation;
@synthesize name;
@synthesize userId;
@synthesize bavatorUrl;
@synthesize savatorUrl;
@synthesize accessUserId;
@synthesize totalDistance;
@synthesize speed;
@synthesize status;
@synthesize userRole;
@synthesize sourceType;
@synthesize authToken=_authToken;
@synthesize isLeader;
@synthesize nowRiddingCount=_nowRiddingCount;
- (id)init
{
    self = [super init];
    if (self) {
        self.name=@"";
        self.savatorUrl=nil;
        self.bavatorUrl=nil;
        speed=0;
        status=0;
        sourceType=SOURCE_SINA;
        self.isLeader=FALSE;
        self.nowRiddingCount=0;
        
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
  float distance=[self.totalDistance longLongValue]*1.0/1000;
  return [NSString stringWithFormat:@"%0.2lf km",distance];
}

-(void)setProperties:(NSDictionary*)dic{
  SET_PROPERTY([dic objectForKey:@"userid"], self.userId);
  SET_PROPERTY([dic objectForKey:@"username"], self.name);
  SET_PROPERTY([dic objectForKey:@"nickname"], self.name);
  SET_PROPERTY([dic objectForKey:@"bavatorurl"], self.bavatorUrl);
  SET_PROPERTY([dic objectForKey:@"savatorurl"], self.savatorUrl);
  SET_PROPERTY([dic objectForKey:@"totalDistance"], self.totalDistance);
  SET_PROPERTY([dic objectForKey:@"sourceid"], self.accessUserId);
  SET_PROPERTY([dic objectForKey:@"accessToken"], self.accessToken);
  self.nowRiddingCount=[[dic objectForKey:@"riddingCount"] intValue];
}

@end
