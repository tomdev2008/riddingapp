//
//  RiddingPictureDao.h
//  Ridding
//
//  Created by zys on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqlUtil.h"
#import "RiddingPicture.h"
@interface RiddingPictureDao : NSObject

@property(nonatomic, retain) SqlUtil *sqlUtil;


+ (RiddingPictureDao*)getSinglton;
-(Boolean)addRiddingPicture:(RiddingPicture*)picture;
-(NSArray*)getRiddingPicture:(long long)riddingId userId:(long long)userId;
-(long long)getMaxRiddingPictureId:(long long)riddingId userId:(long long)userId;
-(BOOL)deleteRiddingPicture:(long long)riddingId userId:(long long)userId dbId:(long long)dbId;
-(int)getNextDbId:(long long)riddingId userId:(long long)userId;
-(BOOL)updateRiddingPictureText:(NSString*)pictureDescription dbId:(long long)dbId;
@end
