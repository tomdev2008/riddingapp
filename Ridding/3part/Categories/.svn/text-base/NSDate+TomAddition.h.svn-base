//
//  NSDate+TomAddition.h
//
//  Created by Chen Jianfei on 2/11/11.
//  Copyright 2011 Fakastudio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(TomAddition)

+ (NSDate*)pd_yesterday;
+ (NSDate*)pd_lastMonth;


- (NSString*)pd_yyyyMMddString;			// 2012-12-12	
- (NSString*)pd_shortDateString;		// 20120303
- (NSString*)pd_yyyyMMddString_CN;		// 2012年08月05日
- (NSString*)pd_yyyyMMddHHmmssString;
- (NSString*)pd_yyyyMMddHHmmString;
- (NSString*)pd_fileNameyyyyMMddHHmmssString;
- (NSString*)pd_yyyyMMddEEString;
- (NSString*)pd_HHmmString;
- (NSString*)pd_nianYueRiString;		// 2012年8月5日
- (NSString*)pd_EEString;
- (NSUInteger)pd_weekDay;
- (NSString*)pd_MdChineseString;		// 8月5日

- (NSDate*)pd_dateByMovingToBeginningOfDay;

// 没有年份
- (NSString*)pd_description;

// 有年份
- (NSString*)pd_description_date;

// 只有日期
- (NSString*)pd_description_dateOnly;

- (BOOL)pd_isEarlierThan:(NSDate*)aDate;
- (BOOL)pd_isSameDate:(NSDate*)aDate;

- (NSDate*)pd_daysBefore:(NSInteger)days;
- (NSUInteger)pd_daysSince:(NSDate*)date;

// 把xxx分钟，转化成 xx小时xx分钟
+ (NSString*)pd_timeIntervalToHourString:(NSUInteger)min;

- (BOOL)pd_isToday;

// 返回24小时制的小时数字
- (NSInteger)pd_hour24;

// 返回当前时间的北京时区时间, receiver 是当前时区
- (NSDate *)pd_localToBeijingDate;

// 返回北京时间对应的本地时区时间,receiver 是北京时区
- (NSDate *)pd_beijingToLocalDate;



@end

