//
//  wCalendarUs.m
//  wCalendar
//
//  Created by masumiya on 2013/02/19.
//  Copyright (c) 2013年 masumiya. All rights reserved.
//

#import "wCalendarUs.h"

@implementation wCalendarUs

/**
 * Holiday Validation
 *
 * @param int year  Year
 * @param int month Month
 * @param int day   Day
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isHoliday:(int)input_year month:(int)input_month day:(int)input_day
{
    [self setDate:input_year month:input_month day:input_day];
    NSLog(@"date is [%d-%d-%d].", year, month, day);
    [self getWeekday:year month:month day:day];
    NSLog(@"week day no is [%d].", weekday);
    
    if (month <= 6) {
        switch (month) {
            case 1:
                if ([self isNewYearDay] == YES) {
                    return YES;
                }
                return [self isMartinLutherKingDay];
            case 2:
                return [self isPresidentDay];
            case 5:
                return [self isMemorialDay];
                
            default:
                return NO;
        }
    } else {
        switch (month) {
            case 7:
                return [self isIndependenceDay];
            case 9:
                return [self isLaborDay];
            case 10:
                return [self isColumbusDay];
            case 11:
                if ([self isVeteransDay] == YES) {
                    return YES;
                }
                return [self isThanksgivingDay];
            case 12:
                return [self isChristmasDay];
                
            default:
                return NO;
        }
    }
    
    return NO;
}

/**
 * Holiday Validation
 *
 * @param NSDate date 日付
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isHoliday:(NSDate*)date
{
    [self setDate:date];
    
    return [self isHoliday:year month:month day:day];
}

/**
 * New Year's Day
 * 1/1
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isNewYearDay
{
    self.holiday_local = @"New Year's Day";
    self.holiday_en = @"New Year's Day";
    
    // in lieu(12/31 on Friday)
    if (month == 12 && day == 31 && weekday == 6) {
        self.holiday_local = @"Holiday in lieu";
        self.holiday_en = @"Holiday in lieu";
        return [self setHoridayInfo:YES];
    }

    if (month != 1 || (day != 1 && day != 2)) {
        return [self setHoridayInfo:NO];
    }
    
    if (day == 1) {
        return [self setHoridayInfo:YES];
    }
    
    // in lieu(1/2 on Monday)
    if (day == 2 && weekday == 2) {
        self.holiday_local = @"Holiday in lieu";
        self.holiday_en = @"Holiday in lieu";
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Martin Luther King Day
 * Third Monday on Jul.
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isMartinLutherKingDay
{
    self.holiday_local = @"Martin Luther King Day";
    self.holiday_en = @"Martin Luther King Day";
    
    if (month != 1 || weekday != 2) {
        return [self setHoridayInfo:NO];
    }

    if (day >= 15 && day <= 21 && weekday == 2) {
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * President's Day
 * Third Monday on Feb.
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isPresidentDay
{
    self.holiday_local = @"President's Day";
    self.holiday_en = @"President's Day";
    
    if (month != 2 || weekday != 2) {
        return [self setHoridayInfo:NO];
    }
    
    if (day >= 15 && day <= 21 && weekday == 2) {
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Memorial Day
 * Last Monday on May.
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isMemorialDay
{
    self.holiday_local = @"Memorial Day";
    self.holiday_en = @"Memorial Day";
    
    if (month != 5 || weekday != 2) {
        return [self setHoridayInfo:NO];
    }
    
    if (day >= 25 && day <= 31 && weekday == 2) {
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Independence Day
 * 7/4
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isIndependenceDay
{
    self.holiday_local = @"Independence Day";
    self.holiday_en = @"Independence Day";
    
    if (month != 7 || day < 3 || day > 5) {
        return [self setHoridayInfo:NO];
    }
    
    if (day == 4) {
        return [self setHoridayInfo:YES];
    }
    
    if ((day == 3 && weekday == 6)
        || (day == 5 && weekday == 2)) {
        self.holiday_local = @"Holiday in lieu";
        self.holiday_en = @"Holiday in lieu";
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Labor Day
 * First Monday on Sep.
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isLaborDay
{
    self.holiday_local = @"Labor Day";
    self.holiday_en = @"Labor Day";
    
    if (month != 9 || weekday != 2) {
        return [self setHoridayInfo:NO];
    }
    
    if (day >= 1 && day <= 7 && weekday == 2) {
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Columbus Day
 * 10/14
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isColumbusDay
{
    self.holiday_local = @"Columbus Day";
    self.holiday_en = @"Columbus Day";
    
    if (month != 10 || day < 13 || day > 15) {
        return [self setHoridayInfo:NO];
    }
    
    if (day == 14) {
        return [self setHoridayInfo:YES];
    }
    
    if ((day == 13 && weekday == 6)
        || (day == 15 && weekday == 2)) {
        self.holiday_local = @"Holiday in lieu";
        self.holiday_en = @"Holiday in lieu";
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Veterans Day
 * 11/11
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isVeteransDay
{
    self.holiday_local = @"Veterans Day";
    self.holiday_en = @"Veterans Day";
    
    if (month != 11 || day < 10 || day > 12) {
        return [self setHoridayInfo:NO];
    }
    
    if (day == 11) {
        return [self setHoridayInfo:YES];
    }
    
    if ((day == 10 && weekday == 6)
        || (day == 12 && weekday == 2)) {
        self.holiday_local = @"Holiday in lieu";
        self.holiday_en = @"Holiday in lieu";
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Thanksgiving Day
 * Forth Thirsday on Nov.
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isThanksgivingDay
{
    self.holiday_local = @"Thanksgiving Day";
    self.holiday_en = @"Thanksgiving Day";
    
    if (month != 11 || weekday != 5) {
        return [self setHoridayInfo:NO];
    }
    
    if (day >= 24 && day <= 30 && weekday == 5) {
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * Christmas Day
 * 12/25
 *
 * @return BOOL if holiday is YES
 *
 * @author Yuichi Masumiya
 * @since  2013-02-19
 */
- (BOOL)isChristmasDay
{
    self.holiday_local = @"Christmas Day";
    self.holiday_en = @"Christmas Day";
    
    if (month != 12 || day < 24 || day > 26) {
        return [self setHoridayInfo:NO];
    }
    
    if (day == 25) {
        return [self setHoridayInfo:YES];
    }
    
    if ((day == 24 && weekday == 6)
        || (day == 26 && weekday == 2)) {
        self.holiday_local = @"Holiday in lieu";
        self.holiday_en = @"Holiday in lieu";
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}
@end
