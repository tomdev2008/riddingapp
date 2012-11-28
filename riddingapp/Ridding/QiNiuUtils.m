//
//  MPQiNiuUtils.m
//  Phamily
//
//  Created by zys on 12-11-10.
//  Copyright (c) 2012年 儒果网络. All rights reserved.
//

#import "QiNiuUtils.h"

@implementation QiNiuUtils


+ (NSString *) getUrlBySize:(CGSize)size url:(NSString*)url type:(QINIUMODE)type{
  return [NSString stringWithFormat:@"%@/w/%0.0f/h/%0.0f",[self getUrlByType:url type:type],size.width,size.height];
}

+ (NSURL *) getUrlBySizeToUrl:(CGSize)size url:(NSString*)url type:(QINIUMODE)type{
  NSString *returnUrl=[NSString stringWithFormat:@"%@/w/%0.0f/h/%0.0f",[self getUrlByType:url type:type],size.width,size.height];
  return [NSURL URLWithString:returnUrl];
}

+ (NSString*) getUrlByType:(NSString*)url type:(QINIUMODE)type{
  switch (type) {
    case DEDEFAULT:
      return [NSString stringWithFormat:@"%@?imageView/1",url];
    case DESHORT:
      return [NSString stringWithFormat:@"%@?imageView/2",url];
    default:
      break;
  }
  return nil;
}
@end
