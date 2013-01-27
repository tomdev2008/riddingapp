//
//  QiNiuErrorConstants.m
//  Phamily
//
//  Created by zys on 12-11-1.
//  Copyright (c) 2013年 zyslovely@gmail.com. All rights reserved.
//

#import "QiNiuErrorConstants.h"

@implementation QiNiuErrorConstants


+ (NSString *)messageByCode:(NSNumber *)code {

  switch ([code intValue]) {
    case 400:

      return @"请求参数错误";
    case 401: {
      return @"认证授权失败，可能是密钥信息不对或者数字签名错误";
    }
    case 405:
      return @"请求方式错误，非预期的请求方式";
    case 599:
      return @"服务端操作失败";
    case 608:
      return @"文件内容被修改";
    case 612:
      return @"指定的文件不存在或已经被删除";
    case 614:
      return @"文件已存在";
    case 630:
      return @"Bucket 数量已达顶限，创建失败";
    case 631:
      return @"指定的 Bucket 不存在";
    case 701:
      return @"上传数据块校验出错";
  }
  return @"上传失败";
}
@end
