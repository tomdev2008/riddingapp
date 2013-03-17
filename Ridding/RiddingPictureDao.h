//
//  RiddingPictureDao.h
//  Ridding
//
//  Created by zys on 13-3-11.
//
//

#import <Foundation/Foundation.h>
#import "RiddingPicture.h"
@interface RiddingPictureDao : NSObject


+ (Boolean)addRiddingPicture:(RiddingPicture*)riddingPicture;

+ (NSArray *)getRiddingPictures;

+ (void)deleteRiddingPicture:(long long)dbId;

+ (int)getRiddingPictureCount;
@end
