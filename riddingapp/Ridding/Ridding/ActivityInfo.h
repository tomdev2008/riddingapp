//
//  ActivityInfo.h
//  Ridding
//
//  Created by Wu Chenhao on 6/9/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityInfo : NSObject 

@property (nonatomic, retain) NSString *createTime;
@property (nonatomic, retain) NSString *serverCreateTime;
@property (nonatomic, retain) NSNumber *dbId;
@property (nonatomic) double distance;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *beginLocation;
@property (nonatomic, retain) NSString *endLocation;
@property (nonatomic, retain)  NSString *mapAvatorPicUrl;
@property (nonatomic, retain)  NSString *leaderSAvatorUrl;
@property (nonatomic, retain)  NSString *leaderName;
@property (nonatomic, retain)  NSString *leaderUserId;
@property (nonatomic)  int userCount;
@property (nonatomic) bool isLeader;



- (void) setProperties:(NSDictionary*)dic;
- (BOOL)isEnd;
- (void)setEnd;
@end
