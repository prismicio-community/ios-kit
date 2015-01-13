
//
//  PIFragmentBoolean.m
//  PIAPI
//
//  Created by Erwan Loisant on 13/01/15.
//  Copyright (c) 2015 Zengularity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIFragmentGeoPoint.h"

@implementation PIFragmentGeoPoint

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (PIFragmentGeoPoint *)initWithJson:(id)jsonObject
{
    self = [self init];
    _latitude = [jsonObject[@"latitude"] doubleValue];
    _longitude = [jsonObject[@"longitude"] doubleValue];
    return self;
}

@end
