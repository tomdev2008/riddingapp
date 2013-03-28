//
//  RiddingMapPointDao.h
//  Ridding
//
//  Created by zys on 13-3-27.
//
//

#import <Foundation/Foundation.h>
@class RiddingMapPoint;
@interface RiddingMapPointDao : NSObject



+ (RiddingMapPoint*)getRiddingMapPoint:(long long)riddingId userId:(long long)userId;

+ (BOOL)addRiddingMapPointToDB:(NSString*)mapPoint riddingId:(long long)riddingId userId:(long long)userId;

+ (BOOL)addOrUpdateRiddingMapPointToDB:(NSString*)mapPoint riddingId:(long long)riddingId userId:(long long)userId;
@end
