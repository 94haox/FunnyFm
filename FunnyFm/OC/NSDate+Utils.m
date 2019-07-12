//
//  NSDate+Utils.m
//  BloodSugar
//
//  Created by PeterPan on 13-12-27.
//  Copyright (c) 2013年 shake. All rights reserved.
//

#import "NSDate+Utils.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#define D_MINUTE 60
#define D_HOUR   3600
#define D_DAY    86400
#define D_WEEK   604800
#define D_YEAR   31556926

@implementation NSDate (Utils)

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:gregorian];
    [dateComps setYear:year];
    [dateComps setMonth:month];
    [dateComps setDay:day];
    [dateComps setTimeZone:systemTimeZone];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:second];
    
    
    return [dateComps date];
}

+ (NSInteger)daysOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
    NSInteger days = [comps day];
    return days;
}

+ (NSInteger)hourOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  unsigned int unitFlags = NSCalendarUnitHour;
  NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
  NSInteger hours = [comps hour];
  return hours;
}

+ (NSInteger)minuteOffsetBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	unsigned int unitFlags = NSCalendarUnitMinute;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate  toDate:endDate  options:0];
	NSInteger minute = [comps minute];
	return minute;
}

+ (NSDate *)dateWithHour:(int)hour
              minute:(int)minute
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:hour];
    [components setMinute:minute];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

+ (NSTimeInterval)getZeroWithTimeInterverl:(NSTimeInterval)timeInterval
{
	NSDate *originalDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
	NSDateFormatter *dateFomater = [[NSDateFormatter alloc]init];
	dateFomater.dateFormat = @"yyyy年MM月dd日";
	NSString *original = [dateFomater stringFromDate:originalDate];
	NSDate *zeroDate = [dateFomater dateFromString:original];
	return [zeroDate timeIntervalSince1970];
}

+ (NSTimeInterval)getFullTimeWithTimeInterverl:(NSTimeInterval)timeInterval
{
	NSDate *originalDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
	NSDateFormatter *dateFomater = [[NSDateFormatter alloc]init];
	dateFomater.dateFormat = @"yyyy年MM月dd日";
	NSString *original = [dateFomater stringFromDate:originalDate];
	NSDate *zeroDate = [dateFomater dateFromString:original];
	return [zeroDate timeIntervalSince1970] + 60*60*24;
}

+ (BOOL)compareTime:(NSString *)time withTime:(NSString *)time2{
	NSArray *times = [time componentsSeparatedByString:@":"];
	NSInteger timeIntervl = [times.firstObject integerValue] * 60 + [times.lastObject integerValue];
	
	NSArray *time2s = [time2 componentsSeparatedByString:@":"];
	NSInteger timeIntervl2 = [time2s.firstObject integerValue] * 60 + [time2s.lastObject integerValue];
	
	return timeIntervl2 > timeIntervl;
}

#pragma mark - Data component
- (NSInteger)year
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month
{
     NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day
{
     NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour
{
     NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
    return [dateComponents minute];
}

- (NSInteger)second
{
     NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:self];
  return [dateComponents second];
}

- (NSString *)weekday
{
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    
    NSDate *date = [NSDate date];
    comps =[calendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal)
                       fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    NSString *week = @"";
    switch (weekday) {
        case 1:
            week = @"星期日";
            break;
        case 2:
            week = @"星期一";
            break;
        case 3:
            week = @"星期二";
            break;
        case 4:
            week = @"星期三";
            break;
        case 5:
            week = @"星期四";
            break;
        case 6:
            week = @"星期五";
            break;
        case 7:
            week = @"星期六";
            break;
            
        default:
            break;
    }
    
    return week;
}




#pragma mark - Time string
- (NSString *)timeHourMinute
{

    return [self timeHourMinuteWithPrefix:NO suffix:NO];
}

- (NSString *)timeHourMinuteWithPrefix
{
    return [self timeHourMinuteWithPrefix:YES suffix:NO];
}

- (NSString *)timeHourMinuteWithSuffix
{
    return [self timeHourMinuteWithPrefix:NO suffix:YES];
}

- (NSString *)timeHourMinuteWithPrefix:(BOOL)enablePrefix suffix:(BOOL)enableSuffix
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:self];
    if (enablePrefix) {
        timeStr = [NSString stringWithFormat:@"%@%@",([self hour] > 12 ? @"下午" : @"上午"),timeStr];
    }
    if (enableSuffix) {
        timeStr = [NSString stringWithFormat:@"%@%@",([self hour] > 12 ? @"pm" : @"am"),timeStr];
    }
    return timeStr;
}


#pragma mark - Date String
- (NSString *)stringTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *str = [formatter stringFromDate:self];
    return str;
}

- (NSString *)stringMonthDay
{
    return [NSDate dateMonthDayWithDate:self];
}

- (NSString *)stringYearMonthDay
{
    return [NSDate stringYearMonthDayWithDate:self];
}

- (NSString *)stringYearMonthDayHourMinuteSecond
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:self];
    return str;
    
}

- (NSString *)stringYearMonthDayCompareToday
{
    NSString *str;
    NSInteger chaDay = [self daysBetweenCurrentDateAndDate];
    if (chaDay == 0) {
        str = @"Today";
    }else if (chaDay == 1){
        str = @"Tomorrow";
    }else if (chaDay == -1){
        str = @"Yesterday";
    }else{
        str = [self stringYearMonthDay];
    }
    
    return str;
}

+ (NSDate *)dateLoacalDate{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	//为了避免时区问题
	format.timeZone = [NSTimeZone systemTimeZone];
	format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [format  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate * localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)yearMonthDayWithDate:(NSDate *)date{
  if (date == nil) {
    date = [NSDate date];
  }
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:@"yyyy-MM-dd"];
  NSString *str = [formatter stringFromDate:date];
  return str;
}



+ (NSString *)dateMonthDayWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM年dd日"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}


#pragma mark - Date formate

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSString *)timestampFormatStringSubSeconds
{
    return @"yyyy-MM-dd HH:mm";
}

#pragma mark - Date adjust
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateByAddingHours: (NSInteger) hours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * hours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

#pragma mark - Relative Dates
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}


- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}


+ (NSDate *) dateStandardFormatTimeZeroWithDate: (NSDate *) aDate{
    NSString *str = [[NSDate yearMonthDayWithDate:aDate]stringByAppendingString:@" 00:00:00"];
    NSDate *date = [NSDate dateFromString:str];
    return date;
}

//+ (NSString *)timeStringWithCMTime:(CMTime)time{
//  Float64 seconds = time.value / time.timescale;
//  // 把seconds当作时间戳得到一个date
//  NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
//
//  // 格林威治标准时间
//  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//  [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//
//  // 设置时间显示格式
//  [formatter setDateFormat:(seconds / 3600 >= 1) ? @"h:mm:ss" : @"mm:ss"];
//
//  // 返回这个date的字符串形式
//  return [formatter stringFromDate:date];
//}



- (NSInteger) daysBetweenCurrentDateAndDate
{
    //只取年月日比较
    NSDate *dateSelf = [NSDate dateStandardFormatTimeZeroWithDate:self];
    NSTimeInterval timeInterval = [dateSelf timeIntervalSince1970];
    NSDate *dateNow = [NSDate dateStandardFormatTimeZeroWithDate:nil];
    NSTimeInterval timeIntervalNow = [dateNow timeIntervalSince1970];
    
    NSTimeInterval cha = timeInterval - timeIntervalNow;
    CGFloat chaDay = cha / 86400.0;
    NSInteger day = chaDay * 1;
    return day;
}
#pragma mark - Date and string convert
+ (NSDate *)dateFromString:(NSString *)string {
    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)chinaDateFromString:(NSString *)string {
	return [NSDate chinaDateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)chinaDateFromString:(NSString *)string withFormat:(NSString *)format{
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	inputFormatter.timeZone = [NSTimeZone systemTimeZone];
	NSDate *date = [inputFormatter dateFromString:string];
	return date;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
	[inputFormatter setDateStyle:NSDateFormatterMediumStyle];
	//为了避免时区问题
//	inputFormatter.timeZone = [NSTimeZone systemTimeZone];
	inputFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSString *)utilsStringFromDate:(NSDate *)date withFormat:(NSString *)formatString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatString];
	//为了避免时区问题
	dateFormatter.timeZone = [NSTimeZone systemTimeZone];
	dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
	NSString *dateStr = [dateFormatter stringFromDate:date];
	return dateStr;
}

- (NSString *)string {
    return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringCutSeconds
{
    return [self stringWithFormat:[NSDate timestampFormatStringSubSeconds]];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

+ (NSString *)dbFormatString {
    return [NSDate timestampFormatString];
}

//根据某个日期 计算相隔时间差 （年龄）
+(NSInteger)dateToOld:(NSString*)bornDateStr{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate * bornDate = [dateFormatter dateFromString:bornDateStr];
	NSDate *currentDate = [NSDate date];
	NSTimeInterval time = [currentDate timeIntervalSinceDate:bornDate];
	NSInteger age = ((NSInteger)time)/(3600*24*365);
	return age;
}


@end
