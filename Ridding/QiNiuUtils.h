//
//  MPQiNiuUtils.h
//  Phamily
//
//  Created by zys on 12-11-10.
//  Copyright (c) 2012年 骑去哪儿网. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum QINIUMODE {
  
  QINIUMODE_DEDEFAULT          = 0, //表示限定目标缩略图的宽度和高度，放大并从缩略图中央处裁剪为指定
  
  //指定 <Width> 和 <Height>，表示限定目标缩略图的长边，短边等比缩略自适应，将缩略图的大小限定在指定的宽高矩形内。
  //指定 <Width> 但不指定 <Height>，表示限定目标缩略图的宽度，高度等比缩略自适应。
  //指定 <Height> 但不指定 <Width>，表示限定目标缩略图的高度，宽度等比缩略自适应。
  QINIUMODE_DESHORT              = 1,
  
} QINIUMODE;
@interface QiNiuUtils : NSObject


+ (NSString *) getUrlBySize:(CGSize)size url:(NSString*)url type:(QINIUMODE)type;

+ (NSURL *) getUrlBySizeToUrl:(CGSize)size url:(NSString*)url type:(QINIUMODE)type;

+ (NSURL *) getUrlByWidthToUrl:(CGFloat)width url:(NSString*)url type:(QINIUMODE)type;

+ (NSURL *) getUrlByHeightToUrl:(CGFloat)height url:(NSString*)url type:(QINIUMODE)type;
@end
