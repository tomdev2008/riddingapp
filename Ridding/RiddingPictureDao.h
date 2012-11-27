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
-(NSArray*)getRiddingPicture:riddingId userId:(NSString*)userId;
-(int)getMaxRiddingPictureId:riddingId userId:(NSString*)userId;
-(BOOL)deleteRiddingPicture:riddingId userId:(NSString*)userId dbId:(NSString*)dbId;
-(int)getNextDbId:(NSString*)riddingId userId:(NSString*)userId;
-(BOOL)updateRiddingPictureText:(NSString*)text dbId:(NSString*)dbId location:(NSString*)location;
@end
