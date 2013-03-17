//
//  UserPay.h
//  Ridding
//
//  Created by zys on 13-3-17.
//
//

#import "BasicObject.h"
#define keyUserPay @"userpay"
typedef enum _UserPayType {
  UserPay_Weather = 1,
  UserPay_HelpUs = 2,
} UserPayType;

typedef enum _UserPayStatus {
  UserPayStatus_Invalid = 0,
  UserPayStatus_Try = 1,
  UserPayStatus_Valid = 2,
} UserPayStatus;

@interface UserPay : BasicObject

@property (nonatomic) long long userId;
@property (nonatomic) UserPayType type;
@property (nonatomic) UserPayStatus status;
@property (nonatomic) int dayLong;
@property (nonatomic) int extdatelong;

@end
