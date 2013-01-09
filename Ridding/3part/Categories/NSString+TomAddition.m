//
//  NSString+TomAddition.m
//  MicroFiction
//
//  Created by Chen Jianfei on 2/11/11.
//  Copyright 2011 Fakastudio. All rights reserved.
//

#import "NSString+TomAddition.h"
#import "NSDate+Addition.h"

@implementation NSString (TomAddition)

- (BOOL)pd_isTrueString {
	
	return [self isEqualToString:@"1"];
}

- (BOOL)pd_isNotEmptyString {
  
	return ![self isEqualToString:@""];
}

- (BOOL)pd_findSubstring:(NSString*)sub{
	
	if(sub){
		if([sub length]>0){
			NSRange range = [self rangeOfString:sub];
			return range.length ==0? NO:YES;
		}
		return YES;
	}
	
	return NO;
}


-(NSString*) pd_substringWithRangeOfStartString:(NSString*)start endString:(NSString*)end {
	
	NSRange sRnage, eRange;
	NSRange mainRange;
	
	sRnage = [self rangeOfString:start];
	eRange = [self rangeOfString:end options:NSBackwardsSearch];
	
	if(sRnage.length==0 && eRange.length==0)
		return self;
	
	if(sRnage.length==0)
		return [self substringToIndex:eRange.location];
	
	if(eRange.length==0)
		return [self substringFromIndex:sRnage.location+sRnage.length];
	
	
	int length = eRange.location - sRnage.location-sRnage.length;
	if(length<0)
		return nil;
	else
		mainRange.length = length;
	
	mainRange.location = sRnage.length + sRnage.location;
	
	return [self substringWithRange:mainRange];
	
}

- (NSString*)pd_substringWithRangeOfStartString:(NSString *)start nextString:(NSString*)nextStr {
	
	NSRange left, next;
  
  if ([start length]==0) {
    
    if([nextStr length]==0) {
      return self;
    }
    
    next = [self rangeOfString:nextStr];
    if (next.length == 0) {
      // 右边没有找到
      return @"";
    }else
      return [self substringToIndex:next.location];
  }
  
	left = [self rangeOfString:start];
	
	NSString *sub;
	if (left.length==0) {
    
    // 左边字符串没有找到
    return @"";
	}else {
    // 找到了左边
    
    if ([nextStr length]==0) {
      // 右边为空
      return [self substringFromIndex:left.location + left.length];
    }
    
		sub = [self substringFromIndex:left.location + left.length];
		next = [sub rangeOfString:nextStr];
		if (next.length==0) {
      // 右边没有找到
			return @"";
		}else {
			return [sub substringToIndex:next.location];
		}
		
	}
}

- (NSString*)pd_substringWithRangeOfStartString:(NSString *)start nextString:(NSString*)next1 orNextString:(NSString*)next2 {
	
	NSRange left, nextRange1, nextRange2;
  
  if ([start length]==0) {
    
    if([next1 length]==0 && [next2 length]==0) {
      return self;
    }
    
    nextRange1 = [self rangeOfString:next1];
    nextRange2 = [self rangeOfString:next2];
		
    if (nextRange1.length == 0 && nextRange2.length == 0) {
      // 右边2个都没有找到
      return @"";
    }else if(nextRange1.length != 0 && nextRange2.length != 0) {
      return [self substringToIndex:MIN(nextRange1.location,nextRange2.location)];
		}else
			return [self substringToIndex:nextRange1.length==0?nextRange2.location:nextRange1.location];
  }
  
	left = [self rangeOfString:start];
	
	NSString *sub;
	if (left.length==0) {
    
    // 左边字符串没有找到
    return @"";
	}else {
    // 找到了左边
    
    if ([next1 length]==0 && [next2 length]==0) {
      // 右边都为空
      return [self substringFromIndex:left.location + left.length];
    }
		
		sub = [self substringFromIndex:left.location + left.length];
		nextRange1 = [sub rangeOfString:next1];
		nextRange2 = [sub rangeOfString:next2];
		
		if([next2 length]==0) {
			
			// 右边有空串
			if (nextRange1.length == 0) {
				// 第一个字符串没有找到
				return [self substringFromIndex:left.location + left.length];
			}
		}
		
		if (nextRange1.length==0  && nextRange2.length == 0) {
      // 右边没有找到
			return @"";
		}else if(nextRange1.length != 0 && nextRange2.length != 0) {
      return [sub substringToIndex:MIN(nextRange1.location,nextRange2.location)];
		}else
			return [sub substringToIndex:nextRange1.length==0?nextRange2.location:nextRange1.location];
	}
}

- (NSDate*)pd_yyyyMMddDate {
	
	NSDateFormatter	*formatter =[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSDate *aDate;
	aDate = [formatter dateFromString:self];
	[formatter release];
	
	return aDate;
}

- (NSDate*)pd_yyyyMMddHHmmssDate {
	
	NSDateFormatter	*formatter =[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *aDate;
	aDate = [formatter dateFromString:self];
	[formatter release];
	
	return aDate;
}

- (NSDate*)pd_yyyyMMddHHmmDate {
	
	NSDateFormatter	*formatter =[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	
	NSDate *aDate;
	aDate = [formatter dateFromString:self];
	[formatter release];
	
	return aDate;
}

- (NSDate*)pd_yyyyMMddEEDate {
  
	NSDateFormatter	*formatter =[[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd EE"];
	
	NSDate *aDate;
	aDate = [formatter dateFromString:self];
	[formatter release];
	
	return aDate;
}

- (NSUInteger) pd_wrapStringLines:(UIFont*)font withWidth:(NSUInteger)width{
	
	CGSize		aSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(width,kMaxPixelOfCellHeight) lineBreakMode:UILineBreakModeTailTruncation];
	
	NSUInteger  lines = aSize.height / font.xHeight ;
	
	return lines;
}

- (NSUInteger) pd_wrapStringHeight:(UIFont*)font withWidth:(NSUInteger)width withMinimalHeight:(NSUInteger)minimalHeight{
	
	CGSize		aSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(width,kMaxPixelOfCellHeight) lineBreakMode:UILineBreakModeTailTruncation];
	NSUInteger height = aSize.height < minimalHeight? minimalHeight:aSize.height;
	
	return height;
}

- (char)pd_asciiAtIndexOf:(NSUInteger)index {
  
	const char* ut8string = [self cStringUsingEncoding:NSUTF8StringEncoding];
	if (index > [self length]-1) {
		return 0;
	}else {
		return ut8string[index];
	}
}

+ (NSDictionary *)pd_parseURLQueryString:(NSString *)queryString {
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
	for(NSString *pair in pairs) {
		NSArray *keyValue = [pair componentsSeparatedByString:@"="];
		if([keyValue count] == 2) {
			NSString *key = [keyValue objectAtIndex:0];
			NSString *value = [keyValue objectAtIndex:1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if(key && value)
				[dict setObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSString *)pd_trimWhiteSpace
{
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString*)changeMMToM{
  return [self substringToIndex:([self length]-3)];
}


- (NSString*)urlEncode {
  
  return (NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
  
}
@end
