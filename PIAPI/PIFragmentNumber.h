//
//  PIFragmentNumber.h
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

@interface PIFragmentNumber : NSObject

+ (PIFragmentNumber *)NumberWithJson:(id)jsonObject;

- (NSNumber *)value;

@end
