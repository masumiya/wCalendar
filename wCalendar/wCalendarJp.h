//
//  wCalendarJp.h
//  wCalendar
//
//  Created by masumiya on 2013/02/03.
//  Copyright (c) 2013年 masumiya. All rights reserved.
//

#import "wCalendar.h"

@interface wCalendarJp : wCalendar

- (BOOL)isHoliday:(NSDate *)date;
- (BOOL)isHoliday:(int)year month:(int)month day:(int)day;

@end
