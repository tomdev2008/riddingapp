//
//  NSString+Addition.h
//
//  Created by Chen Jianfei on 2/11/11.
//  Copyright 2011 Fakastudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define    kMaxPixelOfCellHeight  1000
#define    kMinFontSize      16

@interface NSString (Addition)


- (BOOL)pd_isTrueString;

- (BOOL)pd_isNotEmptyString;

// 日期类
- (NSDate *)pd_yyyyMMddHHmmssDate;

- (NSDate *)pd_yyyyMMddHHmmDate;

- (NSDate *)pd_yyyyMMddDate;

- (NSDate *)pd_yyyyMMddEEDate;

- (NSUInteger)pd_wrapStringHeight:(UIFont *)font withWidth:(NSUInteger)width withMinimalHeight:(NSUInteger)minimalHeight;

- (NSUInteger)pd_wrapStringLines:(UIFont *)font withWidth:(NSUInteger)width;


//去除前后空格
- (NSString *)pd_trimWhiteSpace;

// 左边数第一个left，右边数第一个end
- (NSString *)pd_substringWithRangeOfStartString:(NSString *)start endString:(NSString *)end;

// 左边数第一个left，再出现的下一个next
- (NSString *)pd_substringWithRangeOfStartString:(NSString *)start nextString:(NSString *)next;

// 左边数第一个left，再出现的下一个next, 两个next哪个先出现就截止到哪个
- (NSString *)pd_substringWithRangeOfStartString:(NSString *)start nextString:(NSString *)next1 orNextString:(NSString *)next2;

- (BOOL)pd_findSubstring:(NSString *)sub;


// 返回index的位置ASCII字符
- (char)pd_asciiAtIndexOf:(NSUInteger)index;

// 格式为xxx=111111&xxxxx=2222的字符串转化为key value的NSDictionary
+ (NSDictionary *)pd_parseURLQueryString:(NSString *)queryString;

- (NSString *)changeMMToM;

- (NSString *)urlEncode;

- (NSString *)trim;
@end
