//
//  PIFragmentDate.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 20/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIFragmentDate : NSObject
+ (PIFragmentDate *)dateWithJson:(id)jsonObject;
- (NSDate *)parseDate:(NSString *)value;
- (NSString *)value;
- (NSString *)text;
- (NSDate *)Date;
@end
