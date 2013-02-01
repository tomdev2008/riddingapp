//
//  UIColor+XMin_Color.m
//  Xmin
//
//  Created by XiangBo Kong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//颜色1：#ffffff
//颜色2：#4d9ddf
//颜色3：#fc5e11 橙色
//颜色4：#2ca7ea
//颜色5：#000000
//颜色6：#666666
//颜色7：#333333
//颜色8：#0b79c8
//颜色9：#ff3300
//颜色10：#778aa9
#import "UIColor+XMin.h"

@implementation UIColor (XMin)
+ (UIColor *)color1WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:1.0 green:1.0 blue:1.0 alpha:alpha];
}

+ (UIColor *)color2WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0x4d / 255.0 green:0x9d / 255.0 blue:0xdf / 255.0 alpha:alpha];
}

+ (UIColor *)color3WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0xfc / 255.0 green:0x5e / 255.0 blue:0x11 / 255.0 alpha:alpha];
}

+ (UIColor *)color4WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0x2c / 255.0 green:0xa7 / 255.0 blue:0xea / 255.0 alpha:alpha];
}

+ (UIColor *)color5WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0.0 green:0.0 blue:0.0 alpha:alpha];
}

+ (UIColor *)color6WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0x66 / 255.0 green:0x66 / 255.0 blue:0x66 / 255.0 alpha:alpha];
}

+ (UIColor *)color7WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0x33 / 255.0 green:0x33 / 255.0 blue:0x33 / 255.0 alpha:alpha];
}

+ (UIColor *)color8WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0x0b / 255.0 green:0x79 / 255.0 blue:0xc8 / 255.0 alpha:alpha];
}

+ (UIColor *)color9WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0xff / 255.0 green:0x33 / 255.0 blue:0x00 / 255.0 alpha:alpha];
}

+ (UIColor *)color10WithAlpha:(CGFloat)alpha {

  return [[self class] colorWithRed:0x77 / 255.0 green:0x8a / 255.0 blue:0xa9 / 255.0 alpha:alpha];
}

+ (UIColor *)getColor:(NSString *)hexColor {

  unsigned int red, green, blue;
  NSRange range;
  range.length = 2;

  range.location = 0;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];

  range.location = 2;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];

  range.location = 4;
  [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];

  return [UIColor colorWithRed:(float) (red / 255.0f) green:(float) (green / 255.0f) blue:(float) (blue / 255.0f) alpha:1.0f];
}
@end
