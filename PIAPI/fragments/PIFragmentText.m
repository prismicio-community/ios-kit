//
//  PIFragmentText.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIFragmentText.h"

@interface PIFragmentText ()
{
    NSString *_value;
}
@end

@implementation PIFragmentText

+ (PIFragmentText *)TextWithJson:(id)jsonObject
{
    PIFragmentText *text = [[PIFragmentText alloc] init];
    text->_value = jsonObject[@"value"];
    return text;
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
