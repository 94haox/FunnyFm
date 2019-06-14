//
//  NSDate+Utils.h
//  BloodSugar
//
//  Created by PeterPan on 13-12-27.
//  Copyright (c) 2013年 shake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Utils)

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

+ (NSInteger)hourOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSInteger)daysOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSInteger)minuteOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSDate *)dateWithHour:(int)hour
                  minute:(int)minute;

+ (NSTimeInterval)getZeroWithTimeInterverl:(NSTimeInterval)timeInterval;

+ (NSTimeInterval)getFullTimeWithTimeInterverl:(NSTimeInterval)timeInterval;

#pragma mark - Getter
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSString *)weekday;


#pragma mark - Time string
- (NSString *)timeHourMinute;
- (NSString *)timeHourMinuteWithPrefix;
- (NSString *)timeHourMinuteWithSuffix;
- (NSString *)timeHourMinuteWithPrefix:(BOOL)enablePrefix suffix:(BOOL)enableSuffix;

#pragma mark - Date String
- (NSString *)stringTime;
- (NSString *)stringMonthDay;
- (NSString *)stringYearMonthDay;
- (NSString *)stringYearMonthDayHourMinuteSecond;
+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date;      //date为空时返回的是当前年月日
+ (NSString *)yearMonthDayWithDate:(NSDate *)date;

#pragma mark - Date formate
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)timestampFormatStringSubSeconds;

#pragma mark - Date adjust
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) hours;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
+ (NSDate *) dateLoacalDate;

#pragma mark - Relative dates from the date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *) dateStandardFormatTimeZeroWithDate: (NSDate *) aDate;  //标准格式的零点日期
- (NSInteger) daysBetweenCurrentDateAndDate;                     //负数为过去，正数为未来
+ (BOOL)compareTime:(NSString *)time withTime:(NSString *)time2;
#pragma mark - Date compare
- (BOOL)isEqualToDateIgnoringTime: (NSDate *) aDate;
- (NSString *)stringYearMonthDayCompareToday;                 //返回“今天”，“明天”，“昨天”，或年月日

#pragma mark - Date and string convert
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSDate *)chinaDateFromString:(NSString *)string;
+ (NSDate *)chinaDateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)utilsStringFromDate:(NSDate *)date withFormat:(NSString *)formatString;
- (NSString *)string;
- (NSString *)stringCutSeconds;

#pragma mark - other
//根据某个日期 计算相隔时间差 返回的是年数
+ (NSInteger)dateToOld:(NSString*)bornDateStr;

+ (NSInteger)ceilFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;

@end
