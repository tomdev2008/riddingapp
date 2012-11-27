//
//  UIColor+XMin_Color.h
//  Xmin
//
//  Created by XiangBo Kong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//颜色1：#ffffff
//颜色2：#4d9ddf
//颜色3：#fc5e11
//颜色4：#2ca7ea
//颜色5：#000000
//颜色6：#666666
//颜色7：#333333
//颜色8：#0b79c8
//颜色9：#ff3300
//颜色10：#778aa9
#import <UIKit/UIKit.h>

@interface UIColor (XMin)
+(UIColor*)color1WithAlpha:(CGFloat)alpha;
+(UIColor*)color2WithAlpha:(CGFloat)alpha;
+(UIColor*)color3WithAlpha:(CGFloat)alpha;
+(UIColor*)color4WithAlpha:(CGFloat)alpha;
+(UIColor*)color5WithAlpha:(CGFloat)alpha;
+(UIColor*)color6WithAlpha:(CGFloat)alpha;
+(UIColor*)color7WithAlpha:(CGFloat)alpha;
+(UIColor*)color8WithAlpha:(CGFloat)alpha;
+(UIColor*)color9WithAlpha:(CGFloat)alpha;
+(UIColor*)color10WithAlpha:(CGFloat)alpha;
+(UIColor *)getColor:(NSString *)hexColor;
@end
