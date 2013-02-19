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
 */
/**
 * 祝日かどうか
 *
 * @param int year  西暦年
 * @param int month 月
 * @param int day   日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isHoliday:(int)input_year month:(int)input_month day:(int)input_day
{
    [self setDate:input_year month:input_month day:input_day];
    NSLog(@"date is [%d-%d-%d].", year, month, day);
    [self getWeekday:year month:month day:day];
    NSLog(@"week day no is [%d].", weekday);
    
    // 6,8月に祝日なし
    if (month == 6 || month == 8) {
        return NO;
    }
    
    if (month <= 6) {
        switch (month) {
            case 1:
                if ([self isGantan] == YES) {
                    return YES;
                }
                return [self isSeijinnohi];
            case 2:
                return [self isKenkokukinenbi];
            case 3:
                return [self isShunbunnohi];
            case 4:
                return [self isShowanohi];
            case 5:
                if ([self isKenpokinenbi] == YES) {
                    return YES;
                }
                if ([self isMidorinohi] == YES) {
                    return YES;
                }
                return [self isKodomonohi];
                
            default:
                return NO;
        }
    } else {
        switch (month) {
            case 7:
                return [self isUminohi];
            case 9:
                if ([self isKeironohi] == YES) {
                    return YES;
                }
                return [self isShubunnohi];
            case 10:
                return [self isTaiikunohi];
            case 11:
                if ([self isBunkanohi] == YES) {
                    return YES;
                }
                return [self isKinrokanshanohi];
            case 12:
                return [self isTennotanjobi];
                
            default:
                return NO;
        }
    }

    return NO;
}

/**
 * 祝日かどうか
 *
 * @param NSDate date 日付
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isHoliday:(NSDate*)date
{
    [self setDate:date];
    
    return [self isHoliday:year month:month day:day];
}

/**
 * 元旦かどうか
 * 年のはじめを祝う。
 * 元日			1月1日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isGantan
{
    self.holiday_local = @"元旦";
    self.holiday_en = @"Gantan";

    if (month != 1 || (day != 1 && day != 2)) {
        return [self setHoridayInfo:NO];
    }
    
    // 元日
    if (day == 1) {
        return [self setHoridayInfo:YES];
    }

    // 元日の翌日の振替休日
    if (day == 2 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    
    return [self setHoridayInfo:NO];
}

/**
 * 成人の日かどうか
 * おとなになつたことを自覚し、みずから生き抜こうとする青年を祝いはげます。
 * 成人の日		1月の第2月曜日 1999年までは、1月15日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isSeijinnohi
{
    self.holiday_local = @"成人の日";
    self.holiday_en = @"Seijin no hi";

    if (month != 1) {
        return [self setHoridayInfo:NO];
    }
    if (year >= 2000) {
        if (day >= 8 && day <= 14 && weekday == 2) {
            return [self setHoridayInfo:YES];
        }
        
        return [self setHoridayInfo:NO];
    }
    
    if (day == 15) {
        return [self setHoridayInfo:YES];
    }
    
    // 成人の日の翌日の振替休日
    if (day == 16 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }

    return [self setHoridayInfo:NO];
}

/**
 * 建国記念の日かどうか
 * 建国をしのび、国を愛する心を養う。
 * 建国記念の日	政令で定める日 2月11日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isKenkokukinenbi
{
    self.holiday_local = @"建国記念の日";
    self.holiday_en = @"Kenkokukinen no hi";
    if (month != 2 || (day != 11 && day != 12)) {
        return [self setHoridayInfo:NO];
    }
    // 建国記念の日
    if (day == 11) {
        return [self setHoridayInfo:YES];
    }
	
    // 建国記念の日の翌日の振替休日
    if (day == 12 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 春分の日かどうか
 * 自然をたたえ、生物をいつくしむ。
 * 春分の日		春分日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isShunbunnohi
{
    self.holiday_local = @"春分の日";
    self.holiday_en = @"Shunbun no hi";

    if (month != 3) {
        return [self setHoridayInfo:NO];
    }
    
    // 春分の日計算式
    NSInteger calc_day = floor(20.69115 + ((year - 2000) * 0.242194) - floor((year - 2000) / 4));
    
    if (day == calc_day) {
        return [self setHoridayInfo:YES];
    }
    
    // 春分の日の翌日の振替休日
    if (day == (calc_day + 1) && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 昭和の日かどうか(平成19年〜)
 * 激動の日々を経て、復興を遂げた昭和の時代を顧み、国の将来に思いをいたす。
 * 昭和の日		4月29日(平成18年まではみどりの日)
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isShowanohi
{
    self.holiday_local = @"昭和の日";
    self.holiday_en = @"Showa no hi";

    if (month != 4 || (day != 29 && day != 30)) {
        return [self setHoridayInfo:NO];
    }
    // みどりの日
    if (day == 29) {
        self.holiday_local = @"みどりの日";
        self.holiday_en = @"Midori no hi";
        return [self setHoridayInfo:YES];
    }
	
    // みどりの日の翌日の振替休日
    if (day == 30 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 憲法記念日かどうか
 * 日本国憲法の施行を記念し、国の成長を期する。
 * 憲法記念日		5月3日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isKenpokinenbi
{
    self.holiday_local = @"憲法記念日";
    self.holiday_en = @"Kenpo Kinenbi";
    
   if (month != 5 || (day != 3 && day != 4)) {
        return [self setHoridayInfo:NO];
    }
    // 憲法記念日
    if (day == 3) {
        return [self setHoridayInfo:YES];
    }
	
    // 憲法記念日の翌日の振替休日
    if (day == 4 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * みどりの日かどうか
 * 自然に親しむとともにその恩恵に感謝し、豊かな心をはぐくむ。
 * みどりの日		5月4日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isMidorinohi
{
    self.holiday_local = @"みどりの日";
    self.holiday_en = @"Midori no hi";
    
    if (month != 5 || day != 4 || year < 1986) {
        return [self setHoridayInfo:NO];
    }
    // 1986年以降の5月4日は休日
    if (weekday != 1) { // 日曜日以外
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * こどもの日かどうか
 * こどもの人格を重んじ、こどもの幸福をはかるとともに、母に感謝する。
 * こどもの日		5月5日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isKodomonohi
{
    self.holiday_local = @"こどもの日";
    self.holiday_en = @"Kodomo no hi";
    
    if (month != 5 || (day != 5 && day != 6)) {
        return [self setHoridayInfo:NO];
    }
    // こどもの日
    if (day == 5) {
        return [self setHoridayInfo:YES];
    }
    // こどもの日の翌日の振替休日
    if (day == 6 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 海の日かどうか
 * 海の恩恵に感謝するとともに、海洋国日本の繁栄を願う。
 * 海の日			1998-2002年まで7月20日、それ以降第3月曜日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isUminohi
{
    self.holiday_local = @"海の日";
    self.holiday_en = @"Umi no hi";
    
    if (month != 7 || year < 1998) {
        return [self setHoridayInfo:NO];
    }
    // 海の日
    // 2002年まで
    if (year <= 2002) {
        if (day == 20) {
            return [self setHoridayInfo:YES];
        }
        
        // 海の日の翌日の振替休日
        if (day == 21 && weekday == 2) {
            self.holiday_local = @"振替休日";
            self.holiday_en = @"Hurikae kyujitsu";
            return [self setHoridayInfo:YES];
        }
        return [self setHoridayInfo:NO];
    }
    // 海の日は7月の第3月曜
    if (day >= 15 && day <= 21 && weekday == 2) {
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 敬老の日かどうか
 * 多年にわたり社会につくしてきた老人を敬愛し、長寿を祝う。
 * 敬老の日		2002年まで9月15日、それ以降第3月曜日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isKeironohi
{
    self.holiday_local = @"敬老の日";
    self.holiday_en = @"Keiro no hi";
    
    if (month != 9) {
        return [self setHoridayInfo:NO];
    }
    // 敬老の日
    if (year <= 2002) {
        // 2002年まで
        if (day == 15) {
            return [self setHoridayInfo:YES];
        }
        
        // 敬老の日の翌日の振替休日
        if (day == 16 && weekday == 2) {
            self.holiday_local = @"振替休日";
            self.holiday_en = @"Hurikae kyujitsu";
            return [self setHoridayInfo:YES];
        }
        return [self setHoridayInfo:NO];
    }
    
    // 敬老の日は9月の第3月曜
    if (day >= 15 && day <= 21 && weekday == 2) {
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 秋分の日かどうか
 * 祖先をうやまい、なくなつた人々をしのぶ。
 * 秋分の日		秋分日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isShubunnohi
{
    self.holiday_local = @"秋分の日";
    self.holiday_en = @"Shubun no hi";
    
    if (month != 9) {
        return [self setHoridayInfo:NO];
    }
    // 秋分の日
    // 秋分の日計算式
    NSInteger calc_day = floor(23.09 + ((year - 2000) * 0.242194) - floor((year - 2000) / 4));
    
    if (day == calc_day) {
        return [self setHoridayInfo:YES];
    }
    
    // 秋分の日の翌日の振替休日
    if (day == (calc_day + 1) && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    
    // 21日が敬老の日、23日が秋分の日のときのみ22日(第3火曜日)は休日
    if (day == 22 && calc_day == 23 && weekday == 2) {
        self.holiday_local = @"国民の休日";
        self.holiday_en = @"Kokumin no kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 体育の日かどうか
 * スポーツにしたしみ、健康な心身をつちかう。
 * 体育の日		1999年まで10月10日、それ以降第2月曜日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isTaiikunohi
{
    self.holiday_local = @"体育の日";
    self.holiday_en = @"Taiiku no hi";
    
    if (month != 10) {
        return [self setHoridayInfo:NO];
    }
    // 体育の日
    if (year <= 1999) {
        // 1999年まで
        if (day == 10) {
            return [self setHoridayInfo:YES];
        }
        
        // 体育の日の翌日の振替休日
        if (day == 11 && weekday == 2) {
            self.holiday_local = @"振替休日";
            self.holiday_en = @"Hurikae kyujitsu";
            return [self setHoridayInfo:YES];
        }
        return [self setHoridayInfo:NO];
    }
    // 体育の日は10月の第2月曜
    if (day >= 8 && day <= 14 && weekday == 2) {
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 文化の日かどうか
 * 自由と平和を愛し、文化をすすめる。
 * 文化の日		11月3日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isBunkanohi
{
    self.holiday_local = @"文化の日";
    self.holiday_en = @"Bunka no hi";
    
   if (month != 11) {
        return [self setHoridayInfo:NO];
    }
    // 文化の日
    if (day == 3) {
        return [self setHoridayInfo:YES];
    }
	
    // 文化の日の翌日の振替休日
    if (day == 4 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 勤労感謝の日かどうか
 * 勤労をたつとび、生産を祝い、国民たがいに感謝しあう。
 * 勤労感謝の日		11月23日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isKinrokanshanohi
{
    self.holiday_local = @"勤労感謝の日";
    self.holiday_en = @"Kinrokansha no hi";
    
    if (month != 11) {
        return [self setHoridayInfo:NO];
    }
    // 勤労感謝の日
    if (day == 23) {
        return [self setHoridayInfo:YES];
    }
	
    // 勤労感謝の日の翌日の振替休日
    if (day == 24 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

/**
 * 平成天皇誕生日かどうか
 * 天皇の誕生日を祝う。
 * 平成天皇誕生日		12月23日
 *
 * @return BOOL 祝日ならYES
 *
 * @author Yuichi Masumiya
 * @since  2010-08-27
 */
- (BOOL)isTennotanjobi
{
    self.holiday_local = @"平成天皇誕生日";
    self.holiday_en = @"Heisei tenno tanjobi";

    if (month != 12 || year < 1989) {
        return [self setHoridayInfo:NO];
    }
    // 平成天皇誕生日
    if (day == 23) {
        return [self setHoridayInfo:YES];
    }
    
    // 平成天皇誕生日の翌日の振替休日
    if (day == 24 && weekday == 2) {
        self.holiday_local = @"振替休日";
        self.holiday_en = @"Hurikae kyujitsu";
        return [self setHoridayInfo:YES];
    }
    return [self setHoridayInfo:NO];
}

@end
