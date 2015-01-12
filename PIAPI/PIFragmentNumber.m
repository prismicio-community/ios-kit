//
//  PIFragmentNumber.m
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import "PIFragmentNumber.h"

@interface PIFragmentNumber ()
{
    NSNumber *_value;
}
@end

@implementation PIFragmentNumber

+ (PIFragmentNumber *)NumberWithJson:(id)jsonObject
{
    PIFragmentNumber *number = [[PIFragmentNumber alloc] init];
    number->_value = jsonObject[@"value"];
    return number;
}

- (NSNumber *)value
{
    return _value;
}

@end
