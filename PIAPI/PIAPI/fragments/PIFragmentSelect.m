//
//  PIFragmentSelect.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentSelect.h"

@interface PIFragmentSelect ()
{
    NSString *_value;
}
@end

@implementation PIFragmentSelect

+ (PIFragmentSelect *)SelectWithJson:(id)jsonObject
{
    PIFragmentSelect *select = [[PIFragmentSelect alloc] init];
    select->_value = jsonObject[@"value"];
    return select;
}

- (NSString *)value
{
    return _value;
}

- (NSString *)text
{
    return _value;
}

@end
