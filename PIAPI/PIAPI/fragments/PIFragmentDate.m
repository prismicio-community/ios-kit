//
//  PIFragmentDate.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentDate.h"

@interface PIFragmentDate ()
{
    NSString *_value;  // 2013-08-17
}
@end

@implementation PIFragmentDate

+ (PIFragmentDate *)dateWithJson:(id)jsonObject
{
    PIFragmentDate *date = [[PIFragmentDate alloc] init];
    date->_value = jsonObject[@"value"];
    return date;
}

- (NSDate *)parseDate:(NSString *)value
{
    // If the date formatters aren't already set up, create them and cache them for reuse.
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    // Convert the date string to an NSDate.
    return [dateFormatter dateFromString:value];
}

- (NSString *)value
{
    return _value;
}

- (NSString *)text
{
    return _value;
}

- (NSDate *)Date
{
    return [self parseDate:_value];
}

@end
