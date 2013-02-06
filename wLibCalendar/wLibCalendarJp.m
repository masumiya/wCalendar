//
//  日本のカレンダー
//  wLibCalendarJp.m
//  wLibCalendar
//
//  Created by masumiya on 2013/02/03.
//  Copyright (c) 2013年 masumiya. All rights reserved.
//

#import "wLibCalendarJp.h"

@implementation wLibCalendarJp
/**
 * 祝日計算
 *
 *	昭和23年施行 (1948年〜)
 *	・日曜日（休日）と祝日が重なった場合、翌日を「休日」とする
 *	・祝日と祝日に挟まれた平日は「国民の休日」
 *	2000年からの春分日計算の手順
 *	1. 2000年の太陽の春分点通過日
 *	3月20.69115日
 *	例. 20.69115　（これは、期間中変化しない）
 *	2000年の太陽の秋分点通過日
 *	9月23.09日
 *	2. 1年ごとの春分点通過日の移動量
 *	(西暦年 - 2000年) * 0.242194(日)
 *	例．(2010 - 2000) * 0.242194 = 2.42194
 *	3. 閏年によるリセット量
 *	INT {(西暦年 - 2000年) / 4}(日)
 *	例．INT {(2010 - 2000) / 4} = INT(2.5) = 2
 *	4. 求める年の春分日の計算
 *	INT {(1) + (2) - (3)}(日)
 *	例．INT {20.69115 + 2.42194 - 2} = INT(21.11309) = 21
 *	　　結果：2010年の春分日は　3/21日
 *	春分の日計算式
 *	day = floor(20.69115 + ((year - 2000) * 0.242194) - floor((year - 2000) / 4));
 *	秋分の日計算式
 *	day = floor(23.09 + ((year - 2000) * 0.242194) - floor((year - 2000) / 4));
 *	http://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html
 *	国民の祝日に関する法律
 *	http://koyomi.vis.ne.jp/directjp.cgi?http://koyomi.vis.ne.jp/reki_doc/doc_0330.htm
 *	将来の春分日・秋分日の計算
 *
 * @param int year  年
 * @param int month 月
 * @param int day   日
 * @param int weekday  週値(0:sun〜6:sat)
 *
 * @return bool 祝日ならTRUE
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (bool)isHoliday:(int)year month:(int)month day:(int)day
{
    bool result = NO;
    
    NSLog(@"date is [%d-%d-%d].", year, month, day);
    int weekday = [self getWeekday:year month:month day:day];
    NSLog(@"week day no is [%d].", weekday);
    if (month == 1) {
        if ([self isGantan:month day:day weekday:weekday] == YES) {
            return YES;
        }
        result = [self isSeijinnohi:year month:month day:day weekday:weekday];
    } else if (month == 2) {
        result = [self isKenkokukinenbi:month day:day weekday:weekday];
	} else if (month == 3) {
        result = [self isShunbunnohi:year month:month day:day weekday:weekday];
    } else if (month == 4) {
        result = [self isShowanohi:month day:day weekday:weekday];
	} else if (month == 5) {
        if ([self isKenpokinenbi:month day:day weekday:weekday] == YES) {
            return YES;
        }
        if ([self isMidorinohi:year month:month day:day weekday:weekday] == YES) {
            return YES;
        }
        result = [self isKodomonohi:month day:day weekday:weekday];
	} else if (month == 7) {
        result = [self isUminohi:year month:month day:day weekday:weekday];
    } else if (month == 9) {
        if ([self isKeironohi:year month:month day:day weekday:weekday] == YES) {
            return YES;
        }
        result = [self isShubunnohi:year month:month day:day weekday:weekday];
	} else if (month == 10) {
        result = [self isTaiikunohi:year month:month day:day weekday:weekday];
	} else if (month == 11) {
        if ([self isBunkanohi:month day:day weekday:weekday] == YES) {
            return YES;
        }
        result = [self isKinrokanshanohi:month day:day weekday:weekday];
	} else if (month == 12) {
        result = [self isTennotanjobi:year month:month day:day weekday:weekday];
    }
    // 上記に該当しない日
    return result;
}

/**
 * 元旦かどうか
 * 年のはじめを祝う。
 * 元日			1月1日
 */
- (bool)isGantan:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 1 || (day != 1 && day != 2)) {
        return NO;
    }
    // 元日
    if (day == 1) {
        return YES;
    }
    
    // 元日の翌日の振替休日
    if (day == 2 && weekday == 2) {
        return YES;
    }
    
    return NO;
}

/**
 * 成人の日かどうか
 * おとなになつたことを自覚し、みずから生き抜こうとする青年を祝いはげます。
 * 成人の日		1月の第2月曜日 1999年までは、1月15日
 */
- (bool)isSeijinnohi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 1) {
        return NO;
    }
    if (year >= 2000) {
        if (day >= 8 && day <= 14 && weekday == 2) {
            return YES;
        }
        return NO;
    }
    
    if (day == 15) {
        return YES;
    }
    
    // 成人の日の翌日の振替休日
    if (day == 16 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 建国記念の日かどうか
 * 建国をしのび、国を愛する心を養う。
 * 建国記念の日	政令で定める日 2月11日
 */
- (bool)isKenkokukinenbi:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 2 || (day != 11 && day != 12)) {
        return NO;
    }
    // 建国記念の日
    if (day == 11) {
        return YES;
    }
	
    // 建国記念の日の翌日の振替休日
    if (day == 12 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 春分の日かどうか
 * 自然をたたえ、生物をいつくしむ。
 * 春分の日		春分日
 */
- (bool)isShunbunnohi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 3) {
        return NO;
    }
    
    // 春分の日計算式
    NSInteger calc_day = floor(20.69115 + ((year - 2000) * 0.242194) - floor((year - 2000) / 4));
    
    if (day == calc_day) {
        return YES;
    }
    
    // 春分の日の翌日の振替休日
    if (day == (calc_day + 1) && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 昭和の日かどうか(平成19年〜)
 * 激動の日々を経て、復興を遂げた昭和の時代を顧み、国の将来に思いをいたす。
 * 昭和の日		4月29日(平成18年まではみどりの日)
 */
- (bool)isShowanohi:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 4 || (day != 29 && day != 30)) {
        return NO;
    }
    // みどりの日
    if (day == 29) {
        return YES;
    }
	
    // みどりの日の翌日の振替休日
    if (day == 30 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 憲法記念日かどうか
 * 日本国憲法の施行を記念し、国の成長を期する。
 * 憲法記念日		5月3日
 */
- (bool)isKenpokinenbi:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 5 || (day != 3 && day != 4)) {
        return NO;
    }
    // 憲法記念日
    if (day == 3) {
        return YES;
    }
	
    // 憲法記念日の翌日の振替休日
    if(day == 4 && weekday == 2){
        return YES;
    }
    return NO;
}

/**
 * みどりの日かどうか
 * 自然に親しむとともにその恩恵に感謝し、豊かな心をはぐくむ。
 * みどりの日		5月4日
 */
- (bool)isMidorinohi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 5 || day != 4 || year < 1986) {
        return NO;
    }
    // 1986年以降の5月4日は休日
    if (weekday != 1) { // 日曜日以外
        return YES;
    }
    return NO;
}

/**
 * こどもの日かどうか
 * こどもの人格を重んじ、こどもの幸福をはかるとともに、母に感謝する。
 * こどもの日		5月5日
 */
- (bool)isKodomonohi:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 5 || (day != 5 && day != 6)) {
        return NO;
    }
    // こどもの日
    if (day == 5) {
        return YES;
    }
    // こどもの日の翌日の振替休日
    if (day == 6 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 海の日かどうか
 * 海の恩恵に感謝するとともに、海洋国日本の繁栄を願う。
 * 海の日			1998-2002年まで7月20日、それ以降第3月曜日
 */
- (bool)isUminohi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 7 || year < 1998) {
        return NO;
    }
    // 海の日
    // 2002年まで
    if (year <= 2002) {
        if (day == 20) {
            return YES;
        }
        
        // 海の日の翌日の振替休日
        if (day == 21 && weekday == 2) {
            return YES;
        }
        return NO;
    }
    // 海の日は7月の第3月曜
    if (day >= 15 && day <= 21 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 敬老の日かどうか
 * 多年にわたり社会につくしてきた老人を敬愛し、長寿を祝う。
 * 敬老の日		2002年まで9月15日、それ以降第3月曜日
 */
- (bool)isKeironohi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 9) {
        return NO;
    }
    // 敬老の日
    if (year <= 2002) {
        // 2002年まで
        if (day == 15) {
            return YES;
        }
        
        // 敬老の日の翌日の振替休日
        if (day == 16 && weekday == 2) {
            return YES;
        }
        return NO;
    }
    
    // 敬老の日は9月の第3月曜
    if (day >= 15 && day <= 21 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 秋分の日かどうか
 * 祖先をうやまい、なくなつた人々をしのぶ。
 * 秋分の日		秋分日
 */
- (bool)isShubunnohi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 9) {
        return NO;
    }
    // 秋分の日
    // 秋分の日計算式
    NSInteger calc_day = floor(23.09 + ((year - 2000) * 0.242194) - floor((year - 2000) / 4));
    
    if (day == calc_day) {
        return YES;
    }
    
    // 秋分の日の翌日の振替休日
    if (day == (calc_day + 1) && weekday == 2) {
        return YES;
    }
    
    // 21日が敬老の日、23日が秋分の日のときのみ22日(第3火曜日)は休日
    if (day == 22 && calc_day == 23) {
        if (day >= 16 && day <= 22 && weekday == 2) {
            return YES;
        }
    }
    return NO;
}

/**
 * 体育の日かどうか
 * スポーツにしたしみ、健康な心身をつちかう。
 * 体育の日		1999年まで10月10日、それ以降第2月曜日
 */
- (bool)isTaiikunohi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 10) {
        return NO;
    }
    // 体育の日
    if (year <= 1999) {
        // 1999年まで
        if (day == 10) {
            return YES;
        }
        
        // 体育の日の翌日の振替休日
        if (day == 11 && weekday == 2) {
            return YES;
        }
        return NO;
    }
    // 体育の日は10月の第2月曜
    if (day >= 8 && day <= 14 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 文化の日かどうか
 * 自由と平和を愛し、文化をすすめる。
 * 文化の日		11月3日
 */
- (bool)isBunkanohi:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 11) {
        return NO;
    }
    // 文化の日
    if (day == 3) {
        return YES;
    }
	
    // 文化の日の翌日の振替休日
    if (day == 4 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 勤労感謝の日かどうか
 * 勤労をたつとび、生産を祝い、国民たがいに感謝しあう。
 * 勤労感謝の日		11月23日
 */
- (bool)isKinrokanshanohi:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 11) {
        return NO;
    }
    // 勤労感謝の日
    if (day == 23) {
        return YES;
    }
	
    // 勤労感謝の日の翌日の振替休日
    if (day == 24 && weekday == 2) {
        return YES;
    }
    return NO;
}

/**
 * 平成天皇誕生日かどうか
 * 天皇の誕生日を祝う。
 * 平成天皇誕生日		12月23日
 */
- (bool)isTennotanjobi:(int)year month:(int)month day:(int)day weekday:(int)weekday
{
    if (month != 12 || year < 1989) {
        return NO;
    }
    // 平成天皇誕生日
    if (day == 23) {
        return YES;
    }
    
    // 平成天皇誕生日の翌日の振替休日
    if (day == 24 && weekday == 2) {
        return YES;
    }
    return NO;
}

@end
