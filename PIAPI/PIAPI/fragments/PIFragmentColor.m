//
//  PIFragmentColor.m
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PIFragmentColor.h"

@interface PIFragmentColor ()
{
    NSString *_value;
}
@end

@implementation PIFragmentColor

+ (PIFragmentColor *)ColorWithJson:(id)jsonObject
{
    PIFragmentColor *color = [[PIFragmentColor alloc] init];
    color->_value = jsonObject[@"value"];
    return color;
}

- (UIColor *) ColorFromHexString:(NSString *)hexString {
    // Copied from a StackOverflow answer from Dave DeLong (2010-09-27)
    // http://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)value
{
    return _value;
}

- (NSString *)text
{
    return _value;
}

- (UIColor *)Color
{
    return [self ColorFromHexString: _value];
}

@end
