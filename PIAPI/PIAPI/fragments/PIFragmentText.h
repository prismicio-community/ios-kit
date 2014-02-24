//
//  PIFragmentText.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 09/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

@interface PIFragmentText : NSObject <PIFragment>

+ (PIFragmentText *)TextWithJson:(id)jsonObject;

- (NSString *)value;

- (NSString *)text;

@end
