//
//  MPQiNiuUtils.m
//  Phamily
//
//  Created by zys on 12-11-10.
//  Copyright (c) 2012年 骑去哪儿网. All rights reserved.
//

#import "QiNiuUtils.h"

@implementation QiNiuUtils


+ (NSString *) getUrlBySize:(CGSize)size url:(NSString*)url type:(QINIUMODE)type{
  return  [NSString stringWithFormat:@"%@/w/%0.0f/h/%0.0f",[self getUrlByType:url type:type],size.width*[[UIScreen mainScreen] scale],size.height*[[UIScreen mainScreen] scale]];
}

+ (NSURL *) getUrlBySizeToUrl:(CGSize)size url:(NSString*)url type:(QINIUMODE)type{
  NSString *returnUrl=[NSString stringWithFormat:@"%@/w/%0.0f/h/%0.0f",[self getUrlByType:url type:type],size.width,size.height];
  return [NSURL URLWithString:returnUrl];
}

+ (NSString*) getUrlByType:(NSString*)url type:(QINIUMODE)type{
  switch (type) {
    case QINIUMODE_DEDEFAULT:
      return [NSString stringWithFormat:@"%@?imageView/1",url];
    case QINIUMODE_DESHORT:
      return [NSString stringWithFormat:@"%@?imageView/2",url];
    default:
      break;
  }
  return nil;
}
@end
