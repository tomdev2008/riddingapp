//
//  Public.h
//  Ridding
//
//  Created by zys on 13-2-5.
//
//

#import "BasicObject.h"
#define keyPublic @"public"

typedef enum _PublicType {
  PublicType_None = 0,
  PublicType_Text = 1,
  PublicType_Image =2
} PublicType;

@interface Public : BasicObject

@property (nonatomic) long long dbId;
@property (nonatomic) int weight;
@property (nonatomic) long long riddingId;
@property (nonatomic,copy) NSString *linkText;
@property (nonatomic,copy) NSString *linkImageUrl;
@property (nonatomic,copy) NSString *linkUrl;
@property (nonatomic) int adContentType;
@property (nonatomic,copy) NSString *firstPicUrl;


@end
