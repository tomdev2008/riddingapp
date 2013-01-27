//
//  RiddingLocationDao.h
//  Ridding
//
//  Created by zys on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiddingLocation.h"
#define columCount 5
@interface RiddingLocationDao : NSObject{}


+(Boolean)addRiddingLocation:(long long)riddingId locations:(NSArray*)locations;

+(int)getRiddingLocationCount:(long long)riddingId;

+(NSArray*)getRiddingLocations:(long long)riddingId beginWeight:(int)beginWeight;

+(void)setRiddingLocationToDB:(NSArray*)routes riddingId:(long long)riddingId;


@end

