//
//  Utilities.h
//  Ridding
//
//  Created by zys on 12-9-29.
//
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject


+ (BOOL)isIphone4S;

/** 判断当前设备是否ipad */
+ (BOOL)isIpad;

/* 功能：获取设备类型 */
+ (NSString *)getDeviceVersion;

+ (UITableViewCell*)cellByClassName:(NSString*)className inNib:(NSString *)nibName forTableView:(UITableView *)tableView;

+ (void)alertInstant:(NSString*)message isError:(BOOL)isError;

+ (NSString *)appVersion;
@end
