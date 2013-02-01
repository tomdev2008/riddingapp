
//
//  SinaApiRequestUtil.m
//  Ridding
//
//  Created by zys on 12-3-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SinaApiRequestUtil.h"
#import "ASIFormDataRequest.h"
#import "NSString+TomAddition.h"
static SinaApiRequestUtil *sinaApiRequestUtil=nil;
@implementation SinaApiRequestUtil
@synthesize staticInfo;
@synthesize checker;
- (id)init
{
  self = [super init];
  if (self) {
    staticInfo=[StaticInfo getSinglton];
    checker=[ResponseCodeCheck getSinglton];
  }
  return self;
}

+ (SinaApiRequestUtil*)getSinglton
{
  @synchronized(self) {
    if (sinaApiRequestUtil == nil) {
      sinaApiRequestUtil=[[self alloc] init]; // assignment not done here
    }
  }
  return sinaApiRequestUtil;
}

-(NSDictionary*)getUserInfo{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/users/show.json?access_token=%@&uid=%lld",apiSinaHost,staticInfo.user.accessToken,staticInfo.user.sourceUserId];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIHTTPRequest *arequest=[ASIHTTPRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"GET"];
  [arequest startSynchronous];
  NSString* response= [arequest responseString];
  NSDictionary *responseDic=[response JSONValue];
  if([responseDic objectForKey:@"error_code"]){
    return nil;
  }
  return responseDic;
}

-(NSArray*) getAtUserList:(NSString*)q type:(int)type{
  NSString* urlStr=[NSString stringWithFormat:@"https://%@/2/search/suggestions/at_users.json?access_token=%@&q=%@&count=%d&type=%d&range=%d&uid=%lld",apiSinaHost,staticInfo.user.accessToken,[q urlEncode],30,type,0,staticInfo.user.sourceUserId];
  NSURL *apiUrl=[NSURL URLWithString:urlStr];
  ASIHTTPRequest *asiRequest=[ASIHTTPRequest requestWithURL:apiUrl];
  [asiRequest setRequestMethod:@"GET"];
  [asiRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [asiRequest startSynchronous];
  NSString* response= [asiRequest responseString];
  NSLog(@"%@",response);
  [MobClick event:@"2012112001"];
  return [response JSONValue];
  
}

-(NSString*)checkTokenIsValid{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/account/get_uid.json?access_token=%@",apiSinaHost,staticInfo.user.accessToken];
  methodName= [[NSString alloc]initWithUTF8String:[methodName UTF8String]];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIHTTPRequest *arequest=[ASIHTTPRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"GET"];
  [arequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [arequest startSynchronous];
  NSString* response= [arequest responseString];
  NSDictionary* responseDic=[response JSONValue];
  if([responseDic objectForKey:@"code"]){
    return nil;
  }
  return [NSString stringWithFormat:@"%@",[responseDic objectForKey:@"uid"]];
}


-(void)quit{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/account/end_session.json?access_token=%@",apiSinaHost,staticInfo.user.accessToken];
  methodName= [[NSString alloc]initWithUTF8String:[methodName UTF8String]];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIHTTPRequest *arequest=[ASIHTTPRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"GET"];
  [arequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [arequest startAsynchronous];
}

-(void)friendShip:(NSString*)nickName accessUserId:(NSString*)accessUserId{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/friendships/create.json?access_token=%@&uid=%@",apiSinaHost,staticInfo.user.accessToken,accessUserId];
  methodName= [[NSString alloc]initWithUTF8String:[methodName UTF8String]];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIHTTPRequest *arequest=[ASIHTTPRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"POST"];
  [arequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [arequest startSynchronous];
  //NSString *response=[arequest responseString];
  
}

-(void)sendCreateRidding:(NSString*)status url:(NSString*)url{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/statuses/upload_url_text.json",apiSinaHost];
  methodName= [[NSString alloc]initWithUTF8String:[methodName UTF8String]];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIFormDataRequest *arequest=[ASIFormDataRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"POST"];
  [arequest setPostValue:status forKey:@"status"];
  [arequest setPostValue:staticInfo.user.accessToken forKey:@"access_token"];
  [arequest setPostValue:url forKey:@"url"];
  [arequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [arequest startAsynchronous];
}


-(void)sendLoginRidding:(NSString*)status{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/statuses/update.json",apiSinaHost];
  methodName= [[NSString alloc]initWithUTF8String:[methodName UTF8String]];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIFormDataRequest *arequest=[ASIFormDataRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"POST"];
  [arequest setPostValue:status forKey:@"status"];
  [arequest setPostValue:staticInfo.user.accessToken forKey:@"access_token"];
  [arequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [arequest startAsynchronous];
}

- (NSArray*)getBilateralUserList{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/friendships/friends/bilateral.json?access_token=%@&uid=%lld",apiSinaHost,staticInfo.user.accessToken,staticInfo.user.sourceUserId];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIHTTPRequest *arequest=[ASIHTTPRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"GET"];
  [arequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [arequest startSynchronous];
  NSString* response= [arequest responseString];
  return [[response JSONValue]objectForKey:@"users"];
}
#warning 同步新浪微博
-(void)sendWeiBo:(NSString*)text url:(NSString*)url latitude:(double)latitude longtitude:(double)longtitude{
  NSString* methodName=[NSString stringWithFormat:@"https://%@/2/statuses/upload_url_text.json",apiSinaHost];
  methodName= [[NSString alloc]initWithUTF8String:[methodName UTF8String]];
  NSURL *apiUrl=[NSURL URLWithString:methodName];
  ASIFormDataRequest *arequest=[ASIFormDataRequest requestWithURL:apiUrl];
  [arequest setRequestMethod:@"POST"];
  [arequest setPostValue:text forKey:@"status"];
  [arequest setPostValue:staticInfo.user.accessToken forKey:@"access_token"];
  [arequest setPostValue:url forKey:@"url"];
  [arequest setPostValue:DOUBLE2NUM(latitude) forKey:@"lat"];
  [arequest setPostValue:DOUBLE2NUM(longtitude) forKey:@"long"];
  [arequest setDefaultResponseEncoding:NSUTF8StringEncoding];
  [arequest startSynchronous];
  NSString* response= [arequest responseString];
  NSLog(@"%@",response);
}

//异步请求完成
- (void)requestFinished:(ASIHTTPRequest *)request
{
  // NSLog(@"123");
}
//异步请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
  //NSLog(@"223");
}
@end
