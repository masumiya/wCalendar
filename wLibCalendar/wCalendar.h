//
//  wLibCalendar.h
//  wLibCalendar
//
//  Created by masumiya on 2013/02/03.
//  Copyright (c) 2013年 masumiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wLibCalendar : NSObject
{
@protected
    int year;
    int month;
    int day;
    int weekday;
}
@property (assign) NSString *holiday_en;
@property (assign) NSString *holiday_local;

- (int)getWeekday:(int)year month:(int)month day:(int)day;
- (int)getWeekday:(NSDate *)date;

- (void)setDate:(int)year month:(int)month day:(int)day;
- (void)setDate:(NSDate *)date;

- (BOOL)setHoridayInfo:(BOOL)is_holiday;

@end
