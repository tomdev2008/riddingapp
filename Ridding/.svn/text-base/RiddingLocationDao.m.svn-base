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

-(Boolean)addRiddingLocation:riddingId locations:(NSArray*)locations{
    [sqlUtil readyDatabse];
    for(RiddingLocation *location in locations){
        NSArray *paramarray = [[NSArray alloc] initWithObjects:riddingId,[NSString stringWithFormat:@"%lf",location.latitude],[NSString stringWithFormat:@"%lf",location.longtitude],[NSString stringWithFormat:@"%@",location.toNextDistance],[NSString stringWithFormat:@"%@",location.weight], nil];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO riddinglocation (riddingid, latitude,longtitide,nextDistance,weight) VALUES (?,?,?,?,?)"];
        [sqlUtil dealData:sql paramArray:paramarray];
    }
    return TRUE;
}

-(NSArray*)getRiddingLocations:riddingId beginWeight:(NSNumber*)beginWeight{
    [sqlUtil readyDatabse];
    NSString *sql = [NSString stringWithFormat:@" select * from riddinglocation where riddingid =%@ and weight>=%@ ;",riddingId,beginWeight];
    NSMutableArray *mulArray=[sqlUtil selectData:sql resultColumns:columCount];
    if (!mulArray) {
        return nil;
    }
    NSMutableArray *riddingLocations=[[NSMutableArray alloc]init];
    for(NSArray *row in mulArray){
        RiddingLocation *location=[[RiddingLocation alloc]init];
        location.dbId=[row objectAtIndex:0];
        location.riddingId=[row objectAtIndex:1];
        location.latitude=[[row objectAtIndex:2]floatValue];
        location.longtitude=[[row objectAtIndex:3]floatValue];
        location.toNextDistance=[row objectAtIndex:4];
        location.weight=[row objectAtIndex:5];
        [riddingLocations addObject:location];
    }
    return [riddingLocations copy];

}

-(int)getRiddingLocationCount:riddingId{
    [sqlUtil readyDatabse];
    NSString *sql = [NSString stringWithFormat:@" select count(*) from riddinglocation where riddingid = %@;",riddingId];
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
