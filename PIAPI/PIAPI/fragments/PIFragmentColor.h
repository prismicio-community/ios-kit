//
//  PIFragmentColor.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIFragmentColor : NSObject
+ (PIFragmentColor *)colorWithJson:(id)jsonObject;
- (NSString *)value;
- (NSString *)text;
- (UIColor *)Color;
@end
