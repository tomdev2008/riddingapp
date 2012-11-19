//
//  RiddingPicture.h
//  Ridding
//
//  Created by zys on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiddingPicture : NSObject


@property(nonatomic) double latitude;
@property(nonatomic) double longtitude;
@property(nonatomic,retain) NSString *fileName;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *riddingId;
@property(nonatomic,retain) NSNumber *dbId;
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,retain) NSString *photoUrl;
@property(nonatomic) unsigned long height;
@property(nonatomic) unsigned long width;
//相片描述
@property(nonatomic,retain) NSString *text;
@property(nonatomic,retain) NSString *location;

@end
