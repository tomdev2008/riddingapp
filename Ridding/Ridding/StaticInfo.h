//
//  StaticInfo.h
//  Ridding
//
//  Created by zys on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "FMDatabase.h"

#define kStaticInfo_userId @"userId"
#define kStaticInfo_authToken @"authToken"
#define kStaticInfo_accessUserId @"accessUserId"
#define kStaticInfo_accessToken @"accessToken"
#define kStaticInfo_sourceType @"sourceType"
#define kStaticInfo_backgroundUrl @"backgroundUrl"
#define kStaticInfo_totalDistance @"totalDistance"
#define kStaticInfo_taobaoCode    @"taobaoCode"
#define kStaticInfo_StartApp  @"startApp"
#define kStaticInfo_First_myRidding  @"First_myRidding"
#define kStaticInfo_First_mapCreate  @"First_mapCreate"
#define kStaticInfo_Ios5Tips         @"Ios5Tips"
#define kStaticInfo_Ios5Tips_ShowPhoto         @"Ios5Tips_ShowPhoto"
#define kStaticInfo_SaveInWifi       @"SaveInWifi"
#define kStaticInfo_SaveInWifiTips       @"SaveInWifiTips"


#define kStaticInfo_nickname @"nickname"
#define kStaticInfo_riddingCount @"riddingcount"
#define kStaticInfo_apnsToken @"apnsToken"
#define kStaticInfo_logined @"logined"
#define kStaticInfo_savatorUrl @"savatorUrl"
#define kStaticInfo_bavatorUrl @"bavatorUrl"

@interface StaticInfo : NSObject {
  User *user;
  bool canConnect;
  NSString *plistSavePath;
  //是否已经登陆
  bool logined;
}

@property (nonatomic, retain) User *user;
@property (nonatomic) bool canConnect;
@property (nonatomic, retain) NSString *plistSavePath;
@property (nonatomic) bool logined;
@property (nonatomic, strong) FMDatabase *sqlDB;
@property (nonatomic, retain) NSMutableDictionary *routesDic;

+ (StaticInfo *)getSinglton;

- (NSMutableDictionary *)loadFromFile;

- (BOOL)saveToFile:(NSMutableDictionary *)withData;

- (void)saveDistanceToUserDefault:(int)distance;

- (NSString*)kMapCreateTipsKey;

- (NSString*)kRecomAppKey;

+ (NSString*)routeDicKey:(long long)riddingId userId:(long long)userId;

@end
