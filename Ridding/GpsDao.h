//
//  GpsDao.h
//  Ridding
//
//  Created by zys on 13-3-12.
//
//

#import <Foundation/Foundation.h>
#import "Gps.h"
@interface GpsDao : NSObject


+ (Boolean)addGps:(Gps*)gps;

+ (NSArray *)getGpss:(long long)riddingId userId:(long long)userId;

+ (Boolean)updateReal:(Gps*)gps;
@end
