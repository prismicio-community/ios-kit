//
//  PIFragmentGroup.h
//  PIAPI
//
//  Created by Erwan Loisant on 12/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIWithFragments.h"
#import "PIFragment.h"

@interface PIFragmentGroup : NSObject <PIFragment>

+ (PIFragmentGroup *)GroupWithJson:(id)jsonObject;

@property (nonatomic, readonly) NSArray *groupDocs;

@end
