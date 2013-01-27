//
//  QiNiuErrorConstants.h
//  Phamily
//
//  Created by zys on 12-11-1.
//  Copyright (c) 2013年 zyslovely@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum QiNiuFileServerError_ {

  QI_NIU_FILE_SERVER_UPLOAD_TOKEN_EXPIRED = 101,
  QI_NIU_FILE_SERVER_UPLOAD_FILE_NOT_EXIST = 102
} QiNiuFileServerError;

@interface QiNiuErrorConstants : NSObject {

}

@end
