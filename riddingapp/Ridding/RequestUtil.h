//
//  RequestUtil.h
//  Ridding
//
//  Created by zys on 12-3-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "User.h"
#import "ResponseCodeCheck.h"
#import "RiddingPicture.h"
#import "MapCreateInfo.h"
@protocol RequestUtilDelegate; //代理协议的声明

@interface RequestUtil : NSObject <ASIHTTPRequestDelegate>{
     ResponseCodeCheck *checker;
     StaticInfo *staticInfo;
    id<RequestUtilDelegate> requestUtilDelegate;
}

@property(nonatomic, strong) ResponseCodeCheck *checker;
@property(nonatomic, strong) StaticInfo *staticInfo;
@property(nonatomic, strong) id requestUtilDelegate;


+ (RequestUtil*)getSinglton;

-(Boolean)asySendAndGetAnnotation:(ASIHTTPRequest *)request;

//得到地图上各标志位点的经纬度array
-(NSMutableDictionary*) getMapMessage:(NSString*)riddingId;

//发送自己的经纬度和状态，得到其他队员的经纬度和状态
-(void) sendAndGetAnnotation:(NSString*)riddingId latitude:(NSString*)latitude longtitude:(NSString*)longtitude status:(NSString*)status speend:(long)speed  isGetUsers:(int)isGetUsers;

//得到某个用户的所有地图信息,createTime填-1表示取服务器当前时间
-(NSArray*) getUserMaps:(NSString *)limit createTime:(NSString *)createTime userId:(NSString*)userId isLarger:(int)isLarger;

-(void) sendMapPoiont:(NSString*)riddingId point:(NSArray*)point mapId:(NSString*)mapId distance:(NSNumber*)distance ;
//得到用户列表
-(NSArray*) getUserList:(NSString*)riddingId;
//获取accessuserid
- (NSDictionary*) getAccessUserId:(NSMutableArray *)userIds souceType:(int)sourceType;
//输入userarray，如果accessuserId不在对应ridding中，则添加
-(void) tryAddRiddingUser:(NSString*)riddingId addUsers:(NSArray*)addUser;
//退出骑行活动
- (int) quitActivity:(NSString *)riddingId;
//完成骑行活动
- (void) finishActivity: (NSString *)riddingId;

-(void) deleteRiddingUser:(NSString*)riddingId deleteUserIds:(NSArray*)delteUserIds;

-(NSDictionary*)getUserProfile:(NSString*)userId sourceType:(int)sourceType;

-(void)uploadPhoto:(NSData*)imageData;

-(NSDictionary*)getMapFix:(CGFloat)latitude longtitude:(CGFloat)longtitude;

-(void)sendApns;
//得到已经上传了的图片
-(NSArray*)getUploadedPhoto:riddingId userId:(NSString*)userId;

-(BOOL)uploadRiddingPhoto:(RiddingPicture*)riddingPicture;


-(NSDictionary*)googleGeoCoder:(NSString *)address;

-(NSDictionary*)antyGoogleGeoCoder:(CGFloat)latitude longtitude:(CGFloat)longtitude;

-(NSDictionary*)addRidding:(MapCreateInfo*)info;

@end

//代理协议的实现
@protocol RequestUtilDelegate <NSObject>
-(void)sendAndGetAnnotationReturn:(NSArray*)returnArray; //声明协议方法
@end
