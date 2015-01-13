//
//  PIFragmentBoolean.h
//  PIAPI
//
//  Created by Erwan Loisant on 13/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragment.h"

@interface PIFragmentGeoPoint : NSObject <PIFragment>

@property (readonly) double latitude;
@property (readonly) double longitude;

- (PIFragmentGeoPoint *)initWithJson:(id)jsonObject;

@end
