//
//  RiddingLocationDao.h
//  Ridding
//
//  Created by zys on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqlUtil.h"
#import "RiddingLocation.h"
#define columCount 6
@interface RiddingLocationDao : NSObject{
    SqlUtil *sqlUtil;
}

@property(nonatomic, retain) SqlUtil *sqlUtil;

+ (RiddingLocationDao*)getSinglton;

-(Boolean)addRiddingLocation:(long long)riddingId locations:(NSArray*)locations;

-(int)getRiddingLocationCount:(long long)riddingId;

-(NSArray*)getRiddingLocations:(long long)riddingId beginWeight:(int)beginWeight;


@end

