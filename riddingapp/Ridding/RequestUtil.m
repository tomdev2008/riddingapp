//
//  RequestUtil.m
//  Ridding
//
//  Created by zys on 12-3-21.
//  Copyright 2012骞�__MyCompanyName__. All rights reserved.
//

#import "RequestUtil.h"
#import "ASIFormDataRequest.h"
#import "User.h"

static RequestUtil *requestUtil=nil;
@implementation RequestUtil
@synthesize checker;
@synthesize staticInfo;
@synthesize requestUtilDelegate;
- (id)init
{
  self = [super init];
  if (self) {
    checker=[ResponseCodeCheck getSinglton];
    staticInfo=[StaticInfo getSinglton];
  }
  
  return self;
}
+ (RequestUtil*)getSinglton
{
  @synchronized(self) {
    if (requestUtil == nil) {
      requestUtil=[[self alloc] init];
    }
  }
  return requestUtil;
}

-(NSMutableDictionary*) getMapMessage:(NSString*)riddingId{
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/map/",QIQUNARHOME,riddingId,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString* apiResponse=[asiRequest responseString];
  NSLog(@"apiResponse:%@",apiResponse);
  NSMutableDictionary *responseDic=[apiResponse JSONValue];
  NSLog(@"[asiRequest responseStatusCode]%d",[asiRequest responseStatusCode]);
  if(![checker checkResponseCode:[[responseDic objectForKey:@"code"]intValue] statusCode:[asiRequest responseStatusCode]]){
    return nil;
  }
  return responseDic;
}

-(void) sendAndGetAnnotation:(NSString*)riddingId latitude:(NSString*)latitude longtitude:(NSString*)longtitude status:(NSString*)status speend:(long)speed isGetUsers:(int)isGetUsers {
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/all/",QIQUNARHOME,riddingId,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  asiRequest.delegate=self;
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSArray *keys=[[NSArray alloc]initWithObjects:@"longtitude",@"latitude",@"status",@"speed",@"showTeamer",nil];
  NSArray *values=[[NSArray alloc]initWithObjects:longtitude,latitude,status,[NSString stringWithFormat:@"%ld",speed],[NSString stringWithFormat:@"%d",isGetUsers],nil];
  NSDictionary *dic=[[NSDictionary alloc]initWithObjects:values forKeys:keys];
  NSData *data=[[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startAsynchronous];
}
-(void) sendMapPoiont:(NSString*)riddingId point:(NSArray*)point mapId:(NSString*)mapId distance:(NSNumber*)distance {
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/map/set/",QIQUNARHOME,riddingId,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [point JSONRepresentation], @"points");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, mapId, @"mapid");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, distance, @"distance");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, @"", @"beginlocation");
  
  NSData *data=[[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startAsynchronous];
}

-(NSArray*) getUserList:(NSString*)riddingId{
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/list/",QIQUNARHOME,riddingId,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString* apiResponse=[asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  if(![checker checkResponseCode:[[responseDic objectForKey:@"code"]intValue] statusCode:[asiRequest responseStatusCode]]){
    return nil;
  }
  return [responseDic objectForKey:@"userlist"];
  
}

-(NSArray*) getUserMaps:(NSString *)limit createTime:(NSString *)createTime userId:(NSString*)userId isLarger:(int)isLarger{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%@/list/", QIQUNARHOME, userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, limit, @"limit");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, createTime, @"createtime");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [NSNumber numberWithInt:isLarger], @"larger");

  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  NSDictionary *responseDic = [apiResponse JSONValue];
  if(![checker checkResponseCode:[[responseDic objectForKey:@"code"]intValue] statusCode:[asiRequest responseStatusCode]]){
    return nil;
  }
  return [responseDic objectForKey:@"riddinglist"];
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
  if([self asySendAndGetAnnotation:request]){
    NSString* apiResponse=[request responseString];
    NSDictionary *responseDic=[apiResponse JSONValue];
    if ([requestUtilDelegate respondsToSelector:@selector(sendAndGetAnnotationReturn:)]) {
      [requestUtilDelegate sendAndGetAnnotationReturn:[responseDic objectForKey:@"users"]];
    }
  }
}

-(Boolean)asySendAndGetAnnotation:(ASIHTTPRequest *)request{
  NSString *pattern =[NSString stringWithFormat:@"%@/ridding/.*/user/.*/all/",QIQUNARHOME];
  NSPredicate *urlCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
  return [urlCheck evaluateWithObject:[request url].absoluteString];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
  //  NSLog(@"123");
}

- (NSDictionary*) getAccessUserId:(NSMutableArray *)userIds souceType:(int)sourceType
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%@/sources/list/", QIQUNARHOME, staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
  [dic setValue:[[NSString alloc]initWithFormat:@"%d",sourceType] forKey:@"sourcetype"];
  if(userIds!=nil&&[userIds count]>0){
    [dic setValue:[userIds JSONRepresentation] forKey:@"userids"];
  }
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  dic=[apiResponse JSONValue];
  NSArray* array= [dic objectForKey:@"useridaccessuseridlist"];
  NSMutableDictionary* responseDic=[[NSMutableDictionary alloc]init];
  for(NSDictionary* insideDic in array){
    [responseDic setValue:[insideDic objectForKey:@"accessuserid"] forKey:[insideDic objectForKey:@"userid"]];
  }
  return responseDic;
}

- (int)quitActivity:(NSString *)riddingId
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/quit/", QIQUNARHOME, riddingId, staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  return [[[apiResponse JSONValue]objectForKey:@"code"]intValue];
}

- (void) finishActivity: (NSString *)riddingId
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/action/?type=2", QIQUNARHOME, riddingId, staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  [asiRequest startAsynchronous];
  
}

-(void) tryAddRiddingUser:(NSString*)riddingId addUsers:(NSArray*)addUser{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/addUser/?sourceType=%@", QIQUNARHOME,riddingId,staticInfo.user.userId,[NSString stringWithFormat:@"%d",SOURCE_SINA]]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
  NSMutableArray *array=[[NSMutableArray alloc]init];
  if(addUser!=nil&&[addUser count]>0){
    for(User *user in addUser){
      NSMutableDictionary *tempDic=[[NSMutableDictionary alloc]init];
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(tempDic, user.accessUserId, @"accessuserid");
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(tempDic, user.name, @"nickname");
      [array addObject:tempDic];
    }
  }
  [dic setValue:[array JSONRepresentation] forKey:@"addids"];
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  return;
}

-(void) deleteRiddingUser:(NSString*)riddingId deleteUserIds:(NSArray*)delteUserIds{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/deleteUser/?sourceType=%@", QIQUNARHOME,riddingId,staticInfo.user.userId,[NSString stringWithFormat:@"%d",SOURCE_SINA]]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
  if(delteUserIds!=nil&&[delteUserIds count]>0){
    SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [delteUserIds JSONRepresentation], @"deleteids");
  }
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  return;
}

-(void)uploadPhoto:(NSData*)imageData{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%@/photoUpload/", QIQUNARHOME,staticInfo.user.userId]];
  __block ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:url];
  [asiRequest setData:imageData withFileName:@"picture.jpg" andContentType:@"image/png" forKey:@"file"];
  [asiRequest startAsynchronous];
  return;
}

-(NSDictionary*)getMapFix:(CGFloat)latitude longtitude:(CGFloat)longtitude{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/pub/mapfix/?latitude=%lf&longtitude=%lf", QIQUNARHOME,latitude,longtitude]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  NSDictionary *dic=[apiResponse JSONValue];
  return dic;
  
}

-(void)sendApns{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSString *token= [prefs objectForKey:@"apnsToken"];
  if(token){
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%@/apns/?token=%@", QIQUNARHOME, staticInfo.user.userId,token]];
    ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
    [asiRequest startAsynchronous];
  }
}

-(NSDictionary*) getUserProfile:(NSString*)userId sourceType:(int)sourceType{
  if(!userId){
    return nil;
  }
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%@/profile/?sourceType=%@", QIQUNARHOME,userId,[NSNumber numberWithInt:sourceType]]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  return [apiResponse JSONValue];
  
}

-(NSArray*)getUploadedPhoto:riddingId userId:(NSString*)userId{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/uploaded/", QIQUNARHOME,riddingId,userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  NSLog(@"apiResponse%@",apiResponse);
  NSArray *array=[responseDic objectForKey:@"riddingPictures"];
  NSMutableArray *mulArray=[[NSMutableArray alloc]init];
  for(NSDictionary *dic in array){
    RiddingPicture *picture=[[RiddingPicture alloc]init];
    picture.fileName=[dic objectForKey:@"fileName"];
    picture.photoUrl=[dic objectForKey:@"photoUrl"];
    picture.latitude=[[dic objectForKey:@"latitude"]longValue];
    picture.longtitude=[[dic objectForKey:@"longtitude"]longValue];
    picture.riddingId=riddingId;
    picture.userId=userId;
    [mulArray addObject:picture];
  }
  return mulArray;
}

-(BOOL)uploadRiddingPhoto:(RiddingPicture*)riddingPicture{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%@/user/%@/uploadPhoto/", QIQUNARHOME,riddingPicture.riddingId,riddingPicture.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, riddingPicture.photoUrl, @"photoUrl");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, riddingPicture.fileName, @"localName");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [NSNumber numberWithDouble:riddingPicture.latitude], @"latitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [NSNumber numberWithDouble:riddingPicture.longtitude], @"longtitude");
  
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  
  return TRUE;
}

-(NSDictionary*)addRidding:(MapCreateInfo*)info{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%@/ridding/api/create/", QIQUNARHOME,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [info.points JSONRepresentation], @"points");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [info.mapTaps JSONRepresentation], @"mapTaps");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [info.midLocations JSONRepresentation], @"midlocations");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.beginLocation, @"beginlocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.endLocation, @"endlocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [NSNumber numberWithInt:info.distance], @"distance");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.riddingName, @"riddingname");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.cityName, @"cityname");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.urlKey, @"urlkey");
  
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  if(![checker checkResponseCode:[[responseDic objectForKey:@"code"]intValue] statusCode:[asiRequest responseStatusCode]]){
    return nil;
  }
  return [apiResponse JSONValue];
}

-(NSDictionary*)googleGeoCoder:(NSString *)address{
  address=[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://ditu.google.com/maps/api/geocode/json?address=%@&sensor=false&components=country:cn",address]];
  NSLog(@"%@",url);
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSLog(@"%@",apiResponse);
  return [apiResponse JSONValue];
}

-(NSDictionary*)antyGoogleGeoCoder:(CGFloat)latitude longtitude:(CGFloat)longtitude{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://ditu.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",latitude,longtitude]];
  NSLog(@"%@",url);
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSLog(@"%@",apiResponse);
  return [apiResponse JSONValue];
}
@end
