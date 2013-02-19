//
//  wLibCalendarUs.h
//  wLibCalendar
//
//  Created by masumiya on 2013/02/19.
//  Copyright (c) 2013年 masumiya. All rights reserved.
//

#import "wLibCalendar.h"

@interface wLibCalendarUs : wLibCalendar

- (BOOL)isHoliday:(NSDate *)date;
- (BOOL)isHoliday:(int)year month:(int)month day:(int)day;

@end
