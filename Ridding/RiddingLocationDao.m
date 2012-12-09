//
//  RiddingLocationDao.m
//  Ridding
//
//  Created by zys on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RiddingLocationDao.h"
static RiddingLocationDao *riddingLocationDao=nil;
@implementation RiddingLocationDao
@synthesize sqlUtil;

- (id)init
{
    self = [super init];
    if (self) {
        sqlUtil=[SqlUtil getSinglton];
    }
    return self;
}

+ (RiddingLocationDao*)getSinglton
{
    @synchronized(self) {
        if (riddingLocationDao == nil) {
            riddingLocationDao=[[self alloc] init]; // assignment not done here
        }
    }
    return riddingLocationDao;
}

//   char *sql = "CREATE TABLE IF NOT EXISTS riddinglocation (id INTEGER primary key,riddingid INTEGER, \
latitude text,longtitide text,nextDistance INTEGER,weight INTEGER);";

-(Boolean)addRiddingLocation:(long long)riddingId locations:(NSArray*)locations{
    [sqlUtil readyDatabse];
    for(RiddingLocation *location in locations){
        NSArray *paramarray = [[NSArray alloc] initWithObjects:LONGLONG2NUM(riddingId),DOUBLE2STR(location.latitude),DOUBLE2STR(location.longtitude),INT2STR(location.toNextDistance),INT2STR(location.weight), nil];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO TB_RiddingLocation (riddingid, latitude,longtitude,nextDistance,weight) VALUES (?,?,?,?,?)"];
        [sqlUtil dealData:sql paramArray:paramarray];
    }
    return TRUE;
}

-(NSArray*)getRiddingLocations:(long long)riddingId beginWeight:(int)beginWeight{
    [sqlUtil readyDatabse];
    NSString *sql = [NSString stringWithFormat:@" select * from TB_RiddingLocation where riddingid =%lld@ and weight>=%d ;",riddingId,beginWeight];
    NSMutableArray *mulArray=[sqlUtil selectData:sql resultColumns:columCount];
    if (!mulArray) {
        return nil;
    }
    NSMutableArray *riddingLocations=[[NSMutableArray alloc]init];
    for(NSArray *row in mulArray){
        RiddingLocation *location=[[RiddingLocation alloc]init];
        location.dbId=[[row objectAtIndex:0]longLongValue];
        location.riddingId=[[row objectAtIndex:1]longLongValue];
        location.latitude=[[row objectAtIndex:2]floatValue];
        location.longtitude=[[row objectAtIndex:3]floatValue];
        location.toNextDistance=[[row objectAtIndex:4]intValue];
        location.weight=[[row objectAtIndex:5]intValue];
        [riddingLocations addObject:location];
    }
    return riddingLocations;

}

-(int)getRiddingLocationCount:(long long)riddingId{
    [sqlUtil readyDatabse];
    NSString *sql = [NSString stringWithFormat:@" select count(*) from TB_RiddingLocation where riddingid = %lld;",riddingId];
    NSMutableArray *mulArray=[sqlUtil selectData:sql resultColumns:1];
    if (!mulArray) {
        return -1;
    }
    for(NSArray *row in mulArray){
        return [[row objectAtIndex:0]intValue];
    }
    return -1;
}

@end
