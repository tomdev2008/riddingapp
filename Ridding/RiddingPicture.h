//
//  RiddingPicture.h
//  Ridding
//
//  Created by zys on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicObject.h"
#import "User.h"
@interface RiddingPicture : BasicObject


@property(nonatomic) double latitude;
@property(nonatomic) double longtitude;
@property(nonatomic,copy) NSString *fileName;
@property(nonatomic,retain) User *user;
@property(nonatomic) long long riddingId;
@property(nonatomic) long long dbId;
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,copy) NSString *photoUrl;
@property(nonatomic,copy) NSString *photoKey;
@property(nonatomic) int height;
@property(nonatomic) int width;
@property(nonatomic) long long takePicDateL;
@property(nonatomic,copy) NSString *takePicDateStr;
//相片描述
@property(nonatomic,copy) NSString *pictureDescription;
@property(nonatomic,copy) NSString *location;

@property(nonatomic) BOOL isFirstPic;
@property(nonatomic) long long createTime;

@end
