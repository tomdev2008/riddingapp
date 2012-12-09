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
#import "Comment.h"
@protocol RequestUtilDelegate; //代理协议的声明

@interface RequestUtil : NSObject <ASIHTTPRequestDelegate>{
     ResponseCodeCheck *checker;
     StaticInfo *staticInfo;
}

@property(nonatomic, strong) ResponseCodeCheck *checker;
@property(nonatomic, strong) StaticInfo *staticInfo;
@property(nonatomic, assign) id<RequestUtilDelegate> requestUtilDelegate;


+ (RequestUtil*)getSinglton;

-(Boolean)asySendAndGetAnnotation:(ASIHTTPRequest *)request;

//得到地图上各标志位点的经纬度array
-(NSMutableDictionary*) getMapMessage:(long long)riddingId userId:(long long)userId;

//发送自己的经纬度和状态，得到其他队员的经纬度和状态
-(void) sendAndGetAnnotation:(long long)riddingId latitude:(double)latitude longtitude:(double)longtitude status:(int)status speed:(double)speed isGetUsers:(int)isGetUsers ;

//得到某个用户的所有地图信息,createTime填-1表示取服务器当前时间
-(NSArray*) getUserMaps:(int)limit createTime:(long long)createTime userId:(long long)userId isLarger:(int)isLarger;

-(void) sendMapPoiont:(long long)riddingId point:(NSArray*)point mapId:(long long)mapId distance:(int)distance ;
//得到用户列表
-(NSArray*) getUserList:(long long)riddingId;
//获取accessuserid
- (NSArray*) getAccessUserId:(NSMutableArray *)userIds souceType:(int)sourceType;
//输入userarray，如果accessuserId不在对应ridding中，则添加
-(void) tryAddRiddingUser:(long long)riddingId addUsers:(NSArray*)addUser;
//退出骑行活动
- (int) quitActivity:(long long)riddingId;
//完成骑行活动
- (void) finishActivity: (long long)riddingId;

-(void) deleteRiddingUser:(long long)riddingId deleteUserIds:(NSArray*)delteUserIds;

-(NSDictionary*)getUserProfile:(long long)userId sourceType:(int)sourceType;

-(void)uploadPhoto:(NSData*)imageData;

-(NSDictionary*)getMapFix:(CGFloat)latitude longtitude:(CGFloat)longtitude;

-(void)sendApns;
//得到已经上传了的图片
-(NSArray*)getUploadedPhoto:(long long)riddingId userId:(long long)userId limit:(int)limit lastUpdateTime:(long long)lastUpdateTime;

-(BOOL)uploadRiddingPhoto:(RiddingPicture*)riddingPicture;

-(NSDictionary*)addRidding:(Map*)info;


-(NSDictionary*)addRiddingComment:(Comment*)comment;

-(NSArray*)getRiddingComment:(long long)lastCreateTime
                            limit:(int)limit
                         isLarger:(int)isLarger
                   riddingId:(long long)riddingId;

- (NSArray*)getRiddingPublicList:(long long)lastUpdateTime
                                limit:(int)limit
                              isLarger:(int)isLarger
                              type:(int)type
                               weight:(int)weight;
- (void) likeRidding: (long long)riddingId;
- (void) careRidding: (long long)riddingId;
- (void) useRidding: (long long)riddingId;

@end

//代理协议的实现
@protocol RequestUtilDelegate <NSObject>
-(void)sendAndGetAnnotationReturn:(NSDictionary*)dic; //声明协议方法
@end
