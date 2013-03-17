//
//  RiddingPicture.h
//  Ridding
//
//  Created by zys on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"
#import "User.h"
#import "Ridding.h"

#define keyRiddingPicture @"picture"

@interface RiddingPicture : File


@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nonatomic, retain) User *user;
@property (nonatomic) long long riddingId;
@property (nonatomic) long long dbId;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic) long long takePicDateL;
@property (nonatomic, copy) NSString *takePicDateStr;
//相片描述
@property (nonatomic, copy) NSString *pictureDescription;
@property (nonatomic, copy) NSString *location;

@property (nonatomic) BOOL isFirstPic;
@property (nonatomic) long long createTime;
@property (nonatomic) BOOL liked;
@property (nonatomic) int likeCount;

- (RiddingPicture *)initWithRidding:(int)width height:(int)height ridding:(Ridding *)ridding;


+ (void)uploadRiddingPictureFromLocal;
@end
