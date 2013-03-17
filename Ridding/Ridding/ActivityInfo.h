//
//  ActivityInfo.h
//  Ridding
//
//  Created by Wu Chenhao on 6/9/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicObject.h"
#import "Ridding.h"
#import "Public.h"
typedef enum _ActivityInfoType {
  ActivityInfoType_Going = 0,
  ActivityInfoType_Recom = 1,
} ActivityInfoType;

@interface ActivityInfo : BasicObject {

}

@property (nonatomic, retain) Ridding *ridding;



@end
