//
//  SinaUserProfile.h
//  Ridding
//
//  Created by zys on 12-12-8.
//
//

#import <Foundation/Foundation.h>

@interface SinaUserProfile : BasicObject


@property (nonatomic) long long dbId;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) int province;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *avatar_large;
@property (nonatomic) int followers_count;
@property (nonatomic) int friends_count;
@property (nonatomic) int city;


@property (nonatomic) BOOL isSelected;
@end
