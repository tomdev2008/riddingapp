//
//  ResponseCodeCheck.h
//  Ridding
//
//  Created by zys on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaticInfo.h"
@interface ResponseCodeCheck : NSObject{
    StaticInfo *staticInfo;
}

@property(nonatomic,retain) StaticInfo *staticInfo;

+ (ResponseCodeCheck*)getSinglton;

- (BOOL)checkResponseCode:(int)code statusCode:(int)statusCode;
//检查网络状态
- (BOOL) checkConnect;
- (BOOL) isWifi;
- (BOOL) isWWAN;
@end
