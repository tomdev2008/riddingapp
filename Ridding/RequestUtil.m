//
//  RequestUtil.m
//  Ridding
//
//  Created by zys on 12-3-21.
//  Copyright 2012骞�__MyCompanyName__. All rights reserved.
//

#import "SinaUserProfile.h"
#import "Utilities.h"

@implementation RequestUtil

- (id)init {

  self = [super init];
  if (self) {
    self.staticInfo = [StaticInfo getSinglton];
  }
  return self;
}


- (NSMutableDictionary *)getMapMessage:(long long)riddingId userId:(long long)userId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/map/", QIQUNARHOME, riddingId, userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (void)sendAndGetAnnotation:(long long)riddingId latitude:(double)latitude longtitude:(double)longtitude status:(int)status speed:(double)speed isGetUsers:(int)isGetUsers {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/all/", QIQUNARHOME, riddingId, self.staticInfo.user.userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  asiRequest.delegate = self;
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(longtitude), @"longtitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(latitude), @"latitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(status), @"status");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(speed), @"speed");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isGetUsers), @"showTeamer");
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startAsynchronous];
}

- (NSArray *)getUserList:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/list/", QIQUNARHOME, riddingId, self.staticInfo.user.userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (NSArray *)getUserMaps:(int)limit createTime:(long long)createTime userId:(long long)userId isLarger:(int)isLarger {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/user/%lld/list/", QIQUNARHOME, userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];

  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(limit), @"limit");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(createTime), @"createtime");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isLarger), @"larger");

  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}


- (void)requestFinished:(ASIHTTPRequest *)request {

  NSString *apiResponse = [request responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:request];
  if ([self asySendAndGetAnnotation:request pattern:[NSString stringWithFormat:@"%@/ridding/.*/user/.*/all/", QIQUNARHOME]]) {

    if ([self.delegate respondsToSelector:@selector(asyncReturnDic:)]) {
      [self.delegate asyncReturnDic:responseDic];
    }
    return;
  }
  if ([self asySendAndGetAnnotation:request pattern:[NSString stringWithFormat:@"%@/ridding/.*/user/.*/action/", QIQUNARHOME]]) {
    if ([self.delegate respondsToSelector:@selector(asyncReturnDic:)]) {
      [self.delegate asyncReturnDic:responseDic];
    }
    return;
  }

}

- (Boolean)asySendAndGetAnnotation:(ASIHTTPRequest *)request pattern :(NSString *)pattern {

  NSPredicate *urlCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
  return [urlCheck evaluateWithObject:[request url].absoluteString];
}


- (void)requestFailed:(ASIHTTPRequest *)request {
}

- (int)quitActivity:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/quit/", QIQUNARHOME, riddingId, self.staticInfo.user.userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [[responseDic objectForKey:@"code"] intValue];
}

- (NSDictionary *)finishActivity:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, self.staticInfo.user.userId, RIDDINGACTION_FINISH]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (NSDictionary *)likeRidding:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, self.staticInfo.user.userId, RIDDINGACTION_LIKE]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (void)likeRiddingPicture:(long long)riddingId pictureId:(long long)pictureId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/likePic/?objectId=%lld", QIQUNARHOME, riddingId, self.staticInfo.user.userId, pictureId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startAsynchronous];
}

- (NSDictionary *)careRidding:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, self.staticInfo.user.userId, RIDDINGACTION_CARE]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (NSDictionary *)useRidding:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/?type=%d", QIQUNARHOME, riddingId, self.staticInfo.user.userId, RIDDINGACTION_USE]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (NSDictionary *)tryAddRiddingUser:(long long)riddingId addUsers:(NSArray *)addUser {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/addUser/?sourceType=%@", QIQUNARHOME, riddingId, self.staticInfo.user.userId, [NSString stringWithFormat:@"%d", SOURCE_SINA]]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  NSMutableArray *array = [[NSMutableArray alloc] init];
  if (addUser != nil && [addUser count] > 0) {
    for (SinaUserProfile *user in addUser) {
      NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(tempDic, LONGLONG2NUM(user.dbId), @"accessuserid");
      SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(tempDic, user.screen_name, @"nickname");
      [array addObject:tempDic];
    }
  }
  [dic setValue:[array JSONRepresentation] forKey:@"addids"];
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  //NSString *apiResponse = [asiRequest responseString];
 // NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return nil;//[responseDic objectForKey:@"data"]; 不做回调
}

- (void)deleteRiddingPicture:(long long)riddingId pictureId:(long long)pictureId{

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/picture/%lld/delete", QIQUNARHOME, riddingId, self.staticInfo.user.userId,pictureId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startAsynchronous];
  
}

- (NSDictionary *)deleteRiddingUser:(long long)riddingId deleteUserIds:(NSArray *)delteUserIds {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/deleteUser/?sourceType=%@", QIQUNARHOME, riddingId, self.staticInfo.user.userId, [NSString stringWithFormat:@"%d", SOURCE_SINA]]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  if (delteUserIds != nil && [delteUserIds count] > 0) {
    SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, [delteUserIds JSONRepresentation], @"deleteids");
  }
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startAsynchronous];
  return nil;
//  NSString *apiResponse = [asiRequest responseString];
//  NSDictionary *responseDic=[self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
//#warning 没有回调
//  return [responseDic objectForKey:@"data"];
}


- (NSDictionary *)getMapFix:(CGFloat)latitude longtitude:(CGFloat)longtitude {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/pub/mapfix/?latitude=%lf&longtitude=%lf", QIQUNARHOME, latitude, longtitude]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  DLog(@"apiResponse%@", apiResponse);
  return [responseDic objectForKey:@"data"];
}

- (void)sendApns {

  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSString *token = [prefs objectForKey:kStaticInfo_apnsToken];
  if (token) {
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/user/%lld/apns/?token=%@&version=%@", QIQUNARHOME, self.staticInfo.user.userId, token, [Utilities appVersion]]];
    ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
    [asiRequest startAsynchronous];
  }
}

- (NSDictionary *)getUserProfile:(long long)userId sourceType:(int)sourceType {

  if (!userId) {
    return nil;
  }
  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/user/%lld/profile/?sourceType=%@", QIQUNARHOME, userId, [NSNumber numberWithInt:sourceType]]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];

  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];

}

- (NSArray *)getUploadedPhoto:(long long)riddingId limit:(int)limit lastUpdateTime:(long long)lastUpdateTime {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/uploaded/?limit=%d&lastupdatetime=%lld", QIQUNARHOME, riddingId, limit, lastUpdateTime]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (BOOL)uploadRiddingPhoto:(RiddingPicture *)riddingPicture {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/uploadPhoto/", QIQUNARHOME, riddingPicture.riddingId, [StaticInfo getSinglton].user.userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(riddingPicture.fileKey), @"filekey");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(riddingPicture.latitude), @"latitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, DOUBLE2NUM(riddingPicture.longtitude), @"longtitude");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(riddingPicture.takePicDateL), @"takepicdate");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(riddingPicture.location), @"takepiclocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(riddingPicture.pictureDescription), @"description");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(riddingPicture.width), @"width");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(riddingPicture.height), @"height");
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSLog(@"%@ %@",apiResponse,dic);
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  if ([[responseDic objectForKey:@"code"] intValue] == 1) {
    return TRUE;
  }
  return FALSE;
}

- (NSDictionary *)addRidding:(Ridding *)ridding {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/user/%lld/ridding/api/create/", QIQUNARHOME, self.staticInfo.user.userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR([ridding.map.mapPoint JSONRepresentation]), @"points");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR([ridding.map.mapTaps JSONRepresentation]), @"mapTaps");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR([ridding.map.midLocations JSONRepresentation]), @"midlocations");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(ridding.map.beginLocation), @"beginlocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(ridding.map.endLocation), @"endlocation");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(ridding.map.distance), @"distance");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(ridding.riddingName), @"riddingname");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(ridding.map.cityName), @"cityname");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, SAFESTR(ridding.map.fileKey), @"urlkey");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(ridding.isPublic), @"ispublic");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(ridding.isSyncSina), @"issyncsina");

  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  DLog(@"responseDic%@", responseDic);
  return [responseDic objectForKey:@"data"];
}

- (NSArray *)getRiddingPublicList:(long long)lastUpdateTime
                            limit:(int)limit
                         isLarger:(int)isLarger
                             type:(int)type
                           weight:(int)weight {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/public/list/", QIQUNARHOME]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(lastUpdateTime), @"lastupdatetime");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(limit), @"limit");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isLarger), @"larger");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(type), @"type");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(weight), @"weight");

  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}


- (NSDictionary *)addRiddingComment:(Comment *)comment {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/comment/add/", QIQUNARHOME, comment.riddingId, comment.userId]];
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, comment.text, @"text");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(comment.replyId), @"replyid");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(comment.toUserId), @"touserid");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(comment.commentType), @"commenttype");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, comment.usePicUrl, @"usepicurl");
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];
}

- (NSArray *)getRiddingComment:(long long)lastCreateTime
                         limit:(int)limit
                      isLarger:(int)isLarger
                     riddingId:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/comment/list/", QIQUNARHOME, riddingId]];

  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, LONGLONG2NUM(lastCreateTime), @"lastcreatetime");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(limit), @"limit");
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, INT2NUM(isLarger), @"larger");

  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];

}

- (NSDictionary *)getUserRiddingAction:(long long)riddingId {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/ridding/%lld/user/%lld/action/get/", QIQUNARHOME, riddingId, self.staticInfo.user.userId]];

  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest addRequestHeader:@"authToken" value:self.staticInfo.user.authToken];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];

}

- (NSDictionary *)updateUserBackgroundUrl:(NSString *)urlStr {

  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/user/%lld/background/", QIQUNARHOME, self.staticInfo.user.userId]];

  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, urlStr, @"url");
  NSData *data = [[dic JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
  [asiRequest appendPostData:data];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  NSDictionary *responseDic = [self returnJsonFromResponse:apiResponse asiRequest:asiRequest];
  return [responseDic objectForKey:@"data"];

}

- (NSDictionary *)weatherRequest:(NSString*)latitudeLongitude{
  
  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?format=json&num_of_days=1&key=%@&q=%@",WeatherOnlineKey,latitudeLongitude]];
  
  ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
  [asiRequest startSynchronous];
  NSString *apiResponse = [asiRequest responseString];
  return [[apiResponse JSONValue] objectForKey:@"data"];

}

/**
 * 检查返回的code是否正确
 **/
- (id)returnJsonFromResponse:(NSString *)apiResponse asiRequest:(ASIHTTPRequest *)asiRequest {

  if (apiResponse == nil) {
    return nil;
  }
  NSDictionary *dic = [apiResponse JSONValue];

  int code = [[dic objectForKey:@"code"] intValue];
  if (self.delegate) {
    [self.delegate checkServerError:self code:code asiRequest:asiRequest];
  }
  return dic;
}

@end
