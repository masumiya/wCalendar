//
//  wLibCalendar.m
//  wLibCalendar
//
//  Created by masumiya on 2013/02/03.
//  Copyright (c) 2013年 masumiya. All rights reserved.
//

#import "wLibCalendar.h"

@implementation wLibCalendar

- (int)getWeekday:(int)year month:(int)month day:(int)day
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSString *date = [NSString stringWithFormat:@"%d-%d-%d", year, month, day];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLog(@"Format Date is before [%@] after [%@].", date, [formatter stringFromDate:[formatter dateFromString:date]]);
    
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:[formatter dateFromString:date]];
    
    NSInteger weekday = [weekdayComponents weekday];
    return weekday;
}
@end
