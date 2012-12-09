//
//  SinaApiRequestUtil.h
//  Ridding
//
//  Created by zys on 12-3-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "StaticInfo.h"
#import "SBJson.h"
#import "ResponseCodeCheck.h"
#import "SFHFKeychainUtils.h"
//单例
@interface SinaApiRequestUtil : NSObject <ASIHTTPRequestDelegate>{
    StaticInfo *staticInfo;
    ResponseCodeCheck *checker;
}
@property(nonatomic,retain) StaticInfo *staticInfo;
@property(nonatomic,retain) ResponseCodeCheck *checker;

-(NSDictionary*)getUserInfo;

//通过我得搜索内容，得到我关注或者关注我得用户列表
-(NSArray*) getAtUserList:(NSString*)q type:(NSNumber*)type;

-(NSString*)checkTokenIsValid;
+ (SinaApiRequestUtil*)getSinglton;

-(void)quit;

-(void)friendShip:(NSString*)nickName accessUserId:(NSString*)accessUserId;


-(void)sendCreateRidding:(NSString*)status url:(NSString*)url;

-(void)sendLoginRidding:(NSString*)status;

- (NSArray*)getBilateralUserList;

@end
