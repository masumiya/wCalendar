//
//  wLibCalendar.m
//  wLibCalendar
//
//  Created by masumiya on 2013/02/03.
//  Copyright (c) 2013年 masumiya. All rights reserved.
//

#import "wLibCalendar.h"

@implementation wLibCalendar

@synthesize holiday_en;
@synthesize holiday_local;

/**
 * 指定日の曜日番号を取得する
 *
 * @param int month 西暦年
 * @param int month 月
 * @param int day   日
 *
 * @return int weekday 曜日番号(1:sun〜7:sat)
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (int)getWeekday:(int)input_year month:(int)input_month day:(int)input_day
{
    NSString *date = [NSString stringWithFormat:@"%d-%d-%d", input_year, input_month, input_day];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [self getWeekday:[formatter dateFromString:date]];
}

/**
 * 指定日の曜日番号を取得する
 *
 * @param NSDate date 日付
 *
 * @return int weekday 曜日番号(1:sun〜7:sat)
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (int)getWeekday:(NSDate*)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    NSInteger rs_weekday = [weekdayComponents weekday];
    weekday = rs_weekday;
    return rs_weekday;
}

/**
 * メンバ変数にセット
 *
 * @param NSDate date 日付
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-18
 */
- (void)setDate:(int)input_year month:(int)input_month day:(int)input_day
{
    year = input_year;
    month = input_month;
    day = input_day;
}

/**
 * NSDateからint型に変換してメンバ変数にセット
 *
 * @param NSDate date 日付
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-18
 */
- (void)setDate:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yyyy = [formatter stringFromDate:date];
    year = [yyyy intValue];
    
    [formatter setDateFormat:@"MM"];
    NSString *MM = [formatter stringFromDate:date];
    month = [MM intValue];
    
    [formatter setDateFormat:@"dd"];
    NSString *dd = [formatter stringFromDate:date];
    day = [dd intValue];
}

/**
 * 祝日情報をセット
 *
 * @param BOOL is_holiday 祝日ならYESを指定
 *
 * @return BOOL 祝日ならYES、それ以外はNO
 *
 * @author Yuichi Masumiya
 * @since  2013-02-18
 */
- (BOOL)setHoridayInfo:(BOOL)is_holiday
{
    if (is_holiday == NO) {
        self.holiday_local = @"";
        self.holiday_en = @"";
    }
    return is_holiday;
}
@end
