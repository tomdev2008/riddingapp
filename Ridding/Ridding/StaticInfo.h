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

#define kRecomApp @"recomApp"
#define kStaticInfo_nickname @"nickname"
#define kStaticInfo_riddingCount @"riddingCount"
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

+ (StaticInfo *)getSinglton;

- (NSMutableDictionary *)loadFromFile;

- (BOOL)saveToFile:(NSMutableDictionary *)withData;

- (void)saveDistanceToUserDefault:(int)distance;

@end
