//
//  NSDate+TomAddition.m
//
//  Created by Chen Jianfei on 2/11/11.
//  Copyright 2011 Fakastudio. All rights reserved.
//

#import "NSDate+TomAddition.h"

#define kServerTimeZone           [NSTimeZone timeZoneForSecondsFromGMT:60*60*8]

@implementation NSDate (TomAddition)

+ (NSTimeInterval)localTimeZoneSecondsAheadServerTimeZone {
  
  NSTimeZone *serverTimeZone = kServerTimeZone;
  NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
  return [localTimeZone secondsFromGMT] - [serverTimeZone secondsFromGMT];
}

- (NSDate *)pd_localToBeijingDate {
  
  return [self dateByAddingTimeInterval:-[NSDate localTimeZoneSecondsAheadServerTimeZone]];
}

- (NSDate *)pd_beijingToLocalDate {
  
  return [self dateByAddingTimeInterval:[NSDate localTimeZoneSecondsAheadServerTimeZone]];
}

- (NSString*) pd_yyyyMMddString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}

- (NSString*)pd_yyyyMMddHHmmString {
  
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;  
}

- (NSString*)pd_shortDateString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMdd"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;	
}

- (NSString*)pd_MdChineseString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"M月d日"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}

- (NSString*) pd_yyyyMMddString_CN {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy年MM月dd日"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}

- (NSString*) pd_yyyyMMddHHmmssString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}

- (NSString*)pd_fileNameyyyyMMddHHmmssString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}

- (NSString*)pd_HHmmString {
    
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}


- (NSString*)pd_yyyyMMddEEString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd EE"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;	
}

- (NSString*)pd_nianYueRiString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy年M月d日"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;	
}

- (NSString*) pd_EEString {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EE"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}

- (NSUInteger)pd_weekDay {
	
	NSDateFormatter		*formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"e"];
	
	NSString *str;
	str = [formatter stringFromDate:self];
	[formatter release];
	
	return [str intValue];
}

- (NSDate *) pd_dateByMovingToBeginningOfDay {
	
	unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
	[parts setHour:0];
	[parts setMinute:0];
	[parts setSecond:0];
	return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

+ (NSDate*)pd_yesterday {
	
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.day = -1;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:[NSDate date] options:0];
}

- (NSDate*)pd_daysBefore:(NSInteger)days {
	
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.day = -days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

+ (NSDate*)pd_lastMonth {
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.month = -1;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:[NSDate date] options:0];
}

- (NSString*) pd_description_date {
	
	NSDateFormatter	*formatter = [[NSDateFormatter alloc]init];
	NSDate* beginningOfToday = [[NSDate date] pd_dateByMovingToBeginningOfDay];
	
	NSTimeInterval oneDayInterval = 60*60*24;
	NSTimeInterval interval = [self timeIntervalSinceDate:beginningOfToday];
	
	NSString *returnStr = nil;
	
	if (interval>=0 && interval < oneDayInterval) {
		
		NSDate *now = [NSDate date];
		interval = [now timeIntervalSinceDate:[self pd_beijingToLocalDate]];
		if (interval < 60*60 && interval >= 60*1) {
			returnStr = [NSString stringWithFormat:@"%i分钟前", (int)interval/60 ];
		}else if (interval < 60 *1) {
			returnStr = @"刚才";
		}else
			[formatter setDateFormat:@"HH:mm"];
		
	}else if ( interval <0 && interval >= -oneDayInterval) {
		[formatter setDateFormat:@"昨日"];
	}else if ( interval <0 && interval >= -oneDayInterval*2) {
		[formatter setDateFormat:@"前日"];
	}else {
		[formatter setDateFormat:@"M月d日"];
	}
	
	if (returnStr==nil)
		returnStr = [formatter stringFromDate:[self pd_beijingToLocalDate]];
	
	[formatter release];
	return returnStr;
}

- (NSString*)pd_description_dateOnly {
	
	NSDateFormatter	*formatter = [[NSDateFormatter alloc]init];
	NSDate* beginningOfToday = [[NSDate date] pd_dateByMovingToBeginningOfDay];
	
	NSTimeInterval oneDayInterval = 60*60*24;
	NSTimeInterval interval = [[self pd_beijingToLocalDate] timeIntervalSinceDate:beginningOfToday];
	
	NSString *returnStr = nil;
	
	if (interval>=0 && interval < oneDayInterval) {
		[formatter setDateFormat:@"今日"];
	}else if ( interval <0 && interval >= -oneDayInterval) {
		[formatter setDateFormat:@"昨日"];
	}else if ( interval <0 && interval >= -oneDayInterval*2) {
		[formatter setDateFormat:@"前日"];
	}else {
		[formatter setDateFormat:@"yyyy-MM-dd"];
	}
	
	if (returnStr==nil)
		returnStr = [formatter stringFromDate:[self pd_beijingToLocalDate]];
	
	[formatter release];
	return returnStr;
}

- (NSString*) pd_description {
	
	NSDateFormatter	*formatter = [[NSDateFormatter alloc]init];
	NSDate* beginningOfToday = [[NSDate date] pd_dateByMovingToBeginningOfDay];
	
	NSTimeInterval oneDayInterval = 60*60*24;
	NSTimeInterval interval = [[self pd_beijingToLocalDate] timeIntervalSinceDate:beginningOfToday];
	
	NSString *returnStr = nil;
	
	if (interval>=0 && interval < oneDayInterval) {
		
		NSDate *now = [NSDate date];
		interval = [now timeIntervalSinceDate:[self pd_beijingToLocalDate]];
		if (interval < 60*60 && interval >= 60*1) {
			returnStr = [NSString stringWithFormat:@"%i 分钟前", (int)interval/60 ];
		}else if (interval < 60 *1) {
			returnStr = @"刚才";
		}else
			[formatter setDateFormat:@"今日 HH:mm"];
		
	}else if ( interval <0 && interval >= -oneDayInterval) {
		[formatter setDateFormat:@"昨日 HH:mm"];
	}else if ( interval <0 && interval >= -oneDayInterval*2) {
		[formatter setDateFormat:@"前日 HH:mm"];
	}else {
		[formatter setDateFormat:@"MM-dd HH:mm"];
	}
	
	if (returnStr==nil)
		returnStr = [formatter stringFromDate:[self pd_beijingToLocalDate]];
	
	[formatter release];
	return returnStr;
}

- (BOOL)pd_isEarlierThan:(NSDate*)aDate {
	
	if ([self timeIntervalSinceDate:aDate] >=0) {
		return NO;
	}else {
		return YES;
	}
}

- (NSUInteger)pd_daysSince:(NSDate *)date {
	
	NSTimeInterval interval = [self timeIntervalSinceDate:date];
	return interval/(60*60*24);
}

- (BOOL)pd_isSameDate:(NSDate*)aDate {
	
	unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	
	NSDateComponents* parts1 = [[NSCalendar currentCalendar] components:flags fromDate:self];
	NSDateComponents* parts2 = [[NSCalendar currentCalendar] components:flags fromDate:aDate];
	
	if (parts1.year == parts2.year && parts1.month == parts2.month && parts1.day == parts2.day) {
		return YES;
	}else
		return NO;
}

+ (NSString*)pd_timeIntervalToHourString:(NSUInteger)min {

	if (min < 60) {
		return [NSString stringWithFormat:@"%d分钟",min];
	}else if ( min % 60 == 0)
		return [NSString stringWithFormat:@"%d小时", min / 60 ];
	else
		return [NSString stringWithFormat:@"%d小时%d分钟", min / 60, min % 60];
}

- (BOOL)pd_isToday {
	
	return [[self pd_beijingToLocalDate] pd_isSameDate:[NSDate date]];
}

- (NSInteger)pd_hour24 {
  
	unsigned int flags = NSHourCalendarUnit;
  NSDateComponents *part = [[NSCalendar currentCalendar] components:flags fromDate:self];
  return part.hour;
}



@end
