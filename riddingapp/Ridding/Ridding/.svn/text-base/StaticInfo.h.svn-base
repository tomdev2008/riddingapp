//
//  StaticInfo.h
//  Ridding
//
//  Created by zys on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface StaticInfo : NSObject{
    User *user;
    bool canConnect;
    NSString *plistSavePath;
    //是否已经登陆
    bool logined;
}

@property(nonatomic, retain) User *user;
@property(nonatomic) bool canConnect;
@property(nonatomic, retain) NSString *plistSavePath;
@property(nonatomic) bool logined;

+ (StaticInfo*)getSinglton;
-(NSMutableDictionary *)loadFromFile;
-(BOOL)saveToFile:(NSMutableDictionary *)withData;
-(void)getUserFromPlist;
-(NSMutableDictionary*)saveUserToDictonary;

@end
