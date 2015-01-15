//
//  PIFragmentTimestamp.m
//  PIAPI
//
//  Created by Erwan Loisant on 15/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragmentTimestamp.h"

@implementation PIFragmentTimestamp

@synthesize value = _value;

- (PIFragmentTimestamp *)initWithJson:(id)jsonObject
{
    NSString* dateString = jsonObject[@"value"];
    self->_value = [PIFragmentTimestamp parseDate:dateString];
    return self;
}

+ (NSDate *)parseDate:(NSString *)value
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


@end