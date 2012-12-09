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
#import "NSDate+Addition.h"
#import "SinaUserProfile.h"
static RequestUtil *requestUtil=nil;
@implementation RequestUtil
@synthesize checker;
@synthesize staticInfo;
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

-(NSMutableDictionary*) getMapMessage:(long long)riddingId userId:(long long)userId{
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/map/",QIQUNARHOME,riddingId,userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString* apiResponse=[asiRequest responseString];
  NSMutableDictionary *responseDic=[apiResponse JSONValue];
  if(![checker checkResponseCode:[[responseDic objectForKey:@"code"]intValue] statusCode:[asiRequest responseStatusCode]]){
    return nil;
  }
  NSLog(@"apiResponse%@",responseDic);
  return [responseDic objectForKey:@"data"];
}

-(void) sendAndGetAnnotation:(long long)riddingId latitude:(double)latitude longtitude:(double)longtitude status:(int)status speed:(double)speed isGetUsers:(int)isGetUsers {
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/all/",QIQUNARHOME,riddingId,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  asiRequest.delegate=self;
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(longtitude), @"longtitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(latitude), @"latitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(status), @"status");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(speed), @"speed");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isGetUsers), @"showTeamer");
  NSData *data=[[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startAsynchronous];
}
-(void) sendMapPoiont:(long long)riddingId point:(NSArray*)point mapId:(long long)mapId distance:(int)distance {
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/map/set/",QIQUNARHOME,riddingId,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [point JSONRepresentation], @"points");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(mapId), @"mapid");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(distance), @"distance");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, @"", @"beginlocation");
  
  NSData *data=[[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startAsynchronous];
}

-(NSArray*) getUserList:(long long)riddingId{
  NSURL* url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/list/",QIQUNARHOME,riddingId,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest=[ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString* apiResponse=[asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  if(![checker checkResponseCode:[[responseDic objectForKey:@"code"]intValue] statusCode:[asiRequest responseStatusCode]]){
    return nil;
  }
  return [responseDic objectForKey:@"data"];
}

-(NSArray*) getUserMaps:(int)limit createTime:(long long)createTime userId:(long long)userId isLarger:(int)isLarger{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%lld/list/", QIQUNARHOME, userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(limit), @"limit");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(createTime), @"createtime");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isLarger), @"larger");

  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  NSDictionary *responseDic = [apiResponse JSONValue];
  if(![checker checkResponseCode:[[responseDic objectForKey:@"code"]intValue] statusCode:[asiRequest responseStatusCode]]){
    return nil;
  }
  return [responseDic objectForKey:@"data"];
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
  if([self asySendAndGetAnnotation:request]){
    NSString* apiResponse=[request responseString];
    NSDictionary *responseDic=[apiResponse JSONValue];
    if ([self.requestUtilDelegate respondsToSelector:@selector(sendAndGetAnnotationReturn:)]) {
      [self.requestUtilDelegate sendAndGetAnnotationReturn:responseDic];
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
}

- (NSArray*) getAccessUserId:(NSMutableArray *)userIds souceType:(int)sourceType
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%lld/sources/list/", QIQUNARHOME, staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(sourceType), @"sourcetype");
  if(userIds!=nil&&[userIds count]>0){
    SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [userIds JSONRepresentation], @"userids");
  }
  
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  
  dic=[apiResponse JSONValue];
  
  return [dic objectForKey:@"data"];
}

- (int)quitActivity:(long long)riddingId
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/quit/", QIQUNARHOME, riddingId, staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  return [[[apiResponse JSONValue]objectForKey:@"code"]intValue];
}

- (void) finishActivity: (long long)riddingId
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, staticInfo.user.userId,RIDDINGACTION_FINISH]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  [asiRequest startAsynchronous];
}

- (void) likeRidding: (long long)riddingId
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, staticInfo.user.userId,RIDDINGACTION_LIKE]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  [asiRequest startAsynchronous];
}

- (void) careRidding: (long long)riddingId
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, staticInfo.user.userId,RIDDINGACTION_CARE]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  [asiRequest startAsynchronous];
}

- (void) useRidding: (long long)riddingId
{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, staticInfo.user.userId,RIDDINGACTION_USE]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  [asiRequest startAsynchronous];
}

-(void) tryAddRiddingUser:(long long)riddingId addUsers:(NSArray*)addUser{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/addUser/?sourceType=%@", QIQUNARHOME,riddingId,staticInfo.user.userId,[NSString stringWithFormat:@"%d",SOURCE_SINA]]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
  NSMutableArray *array=[[NSMutableArray alloc]init];
  if(addUser!=nil&&[addUser count]>0){
    for(SinaUserProfile *user in addUser){
      NSMutableDictionary *tempDic=[[NSMutableDictionary alloc]init];
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(tempDic, LONGLONG2NUM(user.dbId), @"accessuserid");
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(tempDic, user.screen_name, @"nickname");
      [array addObject:tempDic];
    }
  }
  [dic setValue:[array JSONRepresentation] forKey:@"addids"];
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  return;
}

-(void) deleteRiddingUser:(long long)riddingId deleteUserIds:(NSArray*)delteUserIds{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/deleteUser/?sourceType=%@", QIQUNARHOME,riddingId,staticInfo.user.userId,[NSString stringWithFormat:@"%d",SOURCE_SINA]]];
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
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%lld/photoUpload/", QIQUNARHOME,staticInfo.user.userId]];
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
  if(apiResponse){
    NSDictionary *dic=[apiResponse JSONValue];
     DLog(@"apiResponse%@",dic);
    return [dic objectForKey:@"data"];
  }
  return nil;

  
}

-(void)sendApns{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSString *token= [prefs objectForKey:@"apnsToken"];
  if(token){
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%lld/apns/?token=%@", QIQUNARHOME, staticInfo.user.userId,token]];
    ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
    [asiRequest startAsynchronous];
  }
}

-(NSDictionary*) getUserProfile:(long long)userId sourceType:(int)sourceType{
  if(!userId){
    return nil;
  }
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%lld/profile/?sourceType=%@", QIQUNARHOME,userId,[NSNumber numberWithInt:sourceType]]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  DLog(@"apiResponse%@",apiResponse);
  NSDictionary *dic=[apiResponse JSONValue];
  if(dic&&[[dic objectForKey:@"code"]intValue]==-444){
    return nil;
  }
  return [dic objectForKey:@"data"];
  
}

-(NSArray*)getUploadedPhoto:(long long)riddingId userId:(long long)userId limit:(int)limit lastUpdateTime:(long long)lastUpdateTime{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/uploaded/?limit=%d&lastupdatetime=%lld", QIQUNARHOME,riddingId,userId,limit,lastUpdateTime]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  NSLog(@"apiResponse%@",responseDic);
  return [responseDic objectForKey:@"data"];
}

-(BOOL)uploadRiddingPhoto:(RiddingPicture*)riddingPicture{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/uploadPhoto/", QIQUNARHOME,riddingPicture.riddingId,[StaticInfo getSinglton].user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, riddingPicture.photoKey, @"photoKey");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, riddingPicture.fileName, @"localName");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(riddingPicture.latitude), @"latitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(riddingPicture.longtitude), @"longtitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(riddingPicture.takePicDateL), @"takepicdate");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, riddingPicture.location, @"takepiclocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, riddingPicture.pictureDescription, @"description");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(riddingPicture.width), @"width");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(riddingPicture.height), @"height");
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  
  return TRUE;
}

-(NSDictionary*)addRidding:(Map*)info{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/user/%lld/ridding/api/create/", QIQUNARHOME,staticInfo.user.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];

  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [info.mapPoint JSONRepresentation], @"points");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [info.mapTaps JSONRepresentation], @"mapTaps");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [info.midLocations JSONRepresentation], @"midlocations");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.beginLocation, @"beginlocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.endLocation, @"endlocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(info.distance), @"distance");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.riddingName, @"riddingname");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.cityName, @"cityname");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, info.urlKey, @"urlkey");
  NSLog(@"%@",dic);
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  //特殊处理，返回200
  if(![responseDic objectForKey:@"code1"]||[[responseDic objectForKey:@"code1"]intValue]!=1){
    [MobClick event:@"2012120101"];
    return nil;
  }
  [MobClick event:@"2012120102"];
  DLog(@"responseDic%@",responseDic);
  return [responseDic objectForKey:@"data"];
}

- (NSArray*)getRiddingPublicList:(long long)lastUpdateTime
                                limit:(int)limit
                             isLarger:(int)isLarger
                                 type:(int)type
                               weight:(int)weight{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/public/list/", QIQUNARHOME]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(lastUpdateTime), @"lastupdatetime");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(limit), @"limit");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isLarger), @"larger");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(type), @"type");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(weight), @"weight");
  
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  DLog(@"%@",responseDic);
  if(![responseDic objectForKey:@"code"]||[[responseDic objectForKey:@"code"]intValue]!=1){
    return nil;
  }
  
  return [responseDic objectForKey:@"data"];
}


-(NSDictionary*)addRiddingComment:(Comment*)comment{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/comment/add/", QIQUNARHOME,comment.riddingId,comment.userId]];
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, comment.text, @"text");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(comment.replyId), @"replyid");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(comment.toUserId), @"touserid");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(comment.commentType), @"commenttype");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, comment.usePicUrl, @"usepicurl");
  [asiRequest addRequestHeader:@"authToken" value:staticInfo.user.authToken];
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  DLog(@"%@",responseDic);
  if(![responseDic objectForKey:@"code"]||[[responseDic objectForKey:@"code"]intValue]!=1){
    return nil;
  }
  
  return [responseDic objectForKey:@"data"];
}

-(NSArray*)getRiddingComment:(long long)lastCreateTime
                            limit:(int)limit
                         isLarger:(int)isLarger
                        riddingId:(long long)riddingId{
  NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/comment/list/", QIQUNARHOME,riddingId]];
  
  ASIHTTPRequest* asiRequest = [ASIHTTPRequest requestWithURL:url];
  NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(lastCreateTime), @"lastcreatetime");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(limit), @"limit");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isLarger), @"larger");
  
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic=[apiResponse JSONValue];
  DLog(@"%@",responseDic);
  if(![responseDic objectForKey:@"code"]||[[responseDic objectForKey:@"code"]intValue]!=1){
    return nil;
  }
  
  return [responseDic objectForKey:@"data"];

}


@end
