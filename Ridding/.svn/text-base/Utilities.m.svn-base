//
//  Utilities.m
//  Ridding
//
//  Created by zys on 12-9-29.
//
//

#import "Utilities.h"
#import <AudioToolbox/AudioToolbox.h>
#import <sys/socket.h> // Per msqr
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import "NSString+MD5Addition.h"
#import "sys/utsname.h"
#include "sys/stat.h"
@implementation Utilities



/** 判断当前设备是否ipad */
+ (BOOL)isIpad
{
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

+ (NSString *)getDeviceVersion
{
  struct utsname systemInfo;
  uname(&systemInfo);
  //get the device model and the system version
  NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
  return machine;
}
@end
