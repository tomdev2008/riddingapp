//
//  Utilities.m
//  Ridding
//
//  Created by zys on 12-9-29.
//
//

#import "Utilities.h"
#import "sys/utsname.h"
#import "SVProgressHUD.h"

@implementation Utilities


/** 判断当前设备是否ipad */
+ (BOOL)isIpad {

  return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIphone4S {

  return [[Utilities getDeviceVersion] isEqualToString:@"iPhone4,1"];
}

/*
 *功能：获取设备类型
 *
 *  AppleTV2,1    AppleTV(2G)
 *  i386          simulator
 *
 *  iPod1,1       iPodTouch(1G)
 *  iPod2,1       iPodTouch(2G)
 *  iPod3,1       iPodTouch(3G)
 *  iPod4,1       iPodTouch(4G)
 *
 *  iPhone1,1     iPhone
 *  iPhone1,2     iPhone 3G
 *  iPhone2,1     iPhone 3GS
 *
 *  iPhone3,1     iPhone 4
 *  iPhone3,3     iPhone4 CDMA版(iPhone4(vz))
 
 *  iPhone4,1     iPhone 4S
 *
 *  iPad1,1       iPad
 *  iPad2,1       iPad2 Wifi版
 *  iPad2,2       iPad2 GSM3G版
 *  iPad2,3       iPad2 CDMA3G版
 *  @return null
 */

+ (NSString *)getDeviceVersion {

  struct utsname systemInfo;
  uname(&systemInfo);
  //get the device model and the system version
  NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
  return machine;
}

+ (UITableViewCell *)cellByClassName:(NSString *)className inNib:(NSString *)nibName forTableView:(UITableView *)tableView {

  Class cellClass = NSClassFromString(className);
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
  if (cell == nil) {

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    
    for (id oneObject in nib){
      if ([oneObject isMemberOfClass:cellClass]){
        return oneObject;
      }
    }
      
  }
  return cell;
}

+ (void)alertInstant:(NSString *)message isError:(BOOL)isError {

  //	UIImage *image = UIIMAGE_FROMPNG(@"btn_xiaoxi");
  //  [[TKAlertCenter defaultCenter] postAlertWithMessage:message image:image];
  //	[[iToast makeText:[NSString stringWithFormat:@"\n\n    %@    \n\n",message]] show];

  if (isError) {
    [SVProgressHUD showErrorWithStatus:message];
  } else {
    [SVProgressHUD showSuccessWithStatus:message];
  }
}

+ (NSString *)appVersion {

  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)targetSize {
  
  int kMaxResolutionWidth = targetSize.width;
  int kMaxResolutionHeight = targetSize.height;
  
  CGImageRef imgRef = image.CGImage;
  
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  CGRect bounds = CGRectMake(0, 0, width, height);
  
  UIImageOrientation orient = image.imageOrientation;
  if (orient == UIImageOrientationUp || orient == UIImageOrientationDown || orient == UIImageOrientationDownMirrored || orient == UIImageOrientationUpMirrored) {
    
  } else {
    
    kMaxResolutionWidth = targetSize.height;
    kMaxResolutionHeight = targetSize.width;
  }
  
  if (width > kMaxResolutionWidth || height > kMaxResolutionHeight) {
    CGFloat ratio = width / height;
    if (ratio > 1) {
      bounds.size.width = kMaxResolutionWidth;
      bounds.size.height = bounds.size.width / ratio;
    }
    else {
      bounds.size.height = kMaxResolutionHeight;
      bounds.size.width = bounds.size.height * ratio;
    }
  }
  
  CGFloat scaleRatio = bounds.size.width / width;
  CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
  CGFloat boundHeight;
  
  switch (orient) {
      
    case UIImageOrientationUp: //EXIF = 1
      transform = CGAffineTransformIdentity;
      break;
      
    case UIImageOrientationUpMirrored: //EXIF = 2
      transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      break;
      
    case UIImageOrientationDown: //EXIF = 3
      transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationDownMirrored: //EXIF = 4
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0);
      break;
      
    case UIImageOrientationLeftMirrored: //EXIF = 5
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
      
    case UIImageOrientationLeft: //EXIF = 6
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
      
    case UIImageOrientationRightMirrored: //EXIF = 7
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeScale(-1.0, 1.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
      
    case UIImageOrientationRight: //EXIF = 8
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
      
    default:
      [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
      
  }
  
  UIGraphicsBeginImageContext(bounds.size);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  }
  else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }
  
  CGContextConcatCTM(context, transform);
  
  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
  UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return imageCopy;
}

+ (CGFloat)deviceVersion {
  
  NSString *osversion = [UIDevice currentDevice].systemVersion;
  return [osversion floatValue];
}
@end
