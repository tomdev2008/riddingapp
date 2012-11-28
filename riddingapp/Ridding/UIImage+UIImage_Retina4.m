//
//  UIImage+UIImage_Retina4.m
//  MMBang
//
//  Created by Tom on 12-9-24.
//  Copyright (c) 2012年 骑去哪儿网. All rights reserved.
//

#import "UIImage+UIImage_Retina4.h"

#ifndef  TARGET_OS_IPHONE
#import <objc/objc-runtime.h>
static Method origImageNamedMethod = nil;
#endif

@implementation UIImage (UIImage_Retina4)


#ifndef  TARGET_OS_IPHONE
+ (void)initialize {
  origImageNamedMethod = class_getClassMethod(self, @selector(imageNamed:));
  method_exchangeImplementations(origImageNamedMethod,
                                 class_getClassMethod(self, @selector(retina4ImageNamed:)));
}
#endif

+ (UIImage *)retina4ImageNamed:(NSString *)imageName type:(NSString *)imageType{
  
  
  NSMutableString *imageNameMutable = [imageName mutableCopy];
  NSRange retinaAtSymbol = [imageName rangeOfString:@"@"];
  
  if (retinaAtSymbol.location != NSNotFound) {
    
    [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    
  } else {
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
      NSRange dot = [imageName rangeOfString:@"."];
      if (dot.location != NSNotFound) {
        [imageNameMutable insertString:@"-568h@2x" atIndex:dot.location];
      } else {
        [imageNameMutable appendString:@"-568h@2x"];
      }
    }
    
  }
  
  
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:imageType];
  
  if (imagePath) {
    
    return UIIMAGE_FROMFILE(imageNameMutable, imageType);
  } else {
    
    return [UIImage imageNamed:imageName];
  }
  return nil;
}

@end