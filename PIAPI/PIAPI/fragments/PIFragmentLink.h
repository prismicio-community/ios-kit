//
//  PIFragmentLink.h
//  PIAPI
//
//  Created by Étienne VALLETTE d'OSIA on 18/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

@protocol PIFragmentLink <PIFragment>

@end

@interface PIFragmentLinkDocument : NSObject <PIFragmentLink>

@end

@interface PIFragmentLink : NSObject
+ (id <PIFragmentLink>)LinkWithJson:(id)jsonObject;
@end